extends SceneTree
## Human presentation checks; input and physics remain owned by the real player.
const SCENE = preload("res://tests/characters/human_character_playtest.tscn")
const PlayerControls = preload("res://player.gd")
const HumanVisual = preload("res://scripts/characters/civilian_visual.gd")
const DialogueProvider = preload("res://scripts/dialogue/dialogue_panel.gd")

var _world: Node3D
var _player: PlayerControls
var _visual: HumanVisual
var _officer: HumanVisual
var _panel: DialogueProvider
var _checks: int = 0
var _failures: int = 0
var _snapshot_dir: String = ""

func _initialize() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--snapshot-dir="):
			_snapshot_dir = argument.trim_prefix("--snapshot-dir=")
	_run.call_deferred()

func _check(condition: bool, label: String) -> void:
	_checks += 1
	if not condition:
		_failures += 1
		push_error("FAIL: " + label)

func _frames(count: int = 3) -> void:
	for index in range(count):
		await physics_frame
	await process_frame
	await process_frame

func _key(code: Key) -> void:
	var event := InputEventKey.new()
	event.keycode = code
	event.physical_keycode = code
	event.pressed = true
	root.push_input(event, true)
	event = event.duplicate() as InputEventKey
	event.pressed = false
	root.push_input(event, true)

func _animator(visual: Node) -> AnimationPlayer:
	return visual.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer

func _meshes(visual: Node) -> Array[Node]:
	return visual.find_children("*", "MeshInstance3D", true, false)

func _bounds(visual: Node) -> AABB:
	var result := AABB()
	var first := true
	for item in _meshes(visual):
		var mesh := item as MeshInstance3D
		var bounds := mesh.global_transform * mesh.get_aabb()
		result = bounds if first else result.merge(bounds)
		first = false
	return result

func _foot_minimum(visual: Node) -> float:
	# CPU-skin only the feet for a few validation samples. No runtime dependency
	# or visual deformation is added to the shipped character component.
	var minimum := INF
	for item in _meshes(visual):
		var mesh := item as MeshInstance3D
		if "Feet" not in mesh.name:
			continue
		var skeleton := mesh.get_node(mesh.skeleton) as Skeleton3D
		var skin := mesh.skin
		var transforms: Array[Transform3D] = []
		for binding in range(skin.get_bind_count()):
			var bone := skin.get_bind_bone(binding)
			if bone < 0:
				bone = skeleton.find_bone(skin.get_bind_name(binding))
			transforms.append(skeleton.get_bone_global_pose(bone) * skin.get_bind_pose(binding))
		for surface in range(mesh.mesh.get_surface_count()):
			var arrays := mesh.mesh.surface_get_arrays(surface)
			var vertices: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
			var bones: PackedInt32Array = arrays[Mesh.ARRAY_BONES]
			var weights: PackedFloat32Array = arrays[Mesh.ARRAY_WEIGHTS]
			var influences: int = bones.size() / vertices.size()
			for vertex in range(vertices.size()):
				var skinned := Vector3.ZERO
				for influence in range(influences):
					var offset := vertex * influences + influence
					if weights[offset] > 0.0:
						skinned += (transforms[bones[offset]] * vertices[vertex]) * weights[offset]
				minimum = minf(minimum, (skeleton.global_transform * skinned).y)
	return minimum

func _snapshot(name: String) -> void:
	if _snapshot_dir.is_empty() or DisplayServer.get_name() == "headless":
		return
	DirAccess.make_dir_recursive_absolute(_snapshot_dir)
	await RenderingServer.frame_post_draw
	var path := _snapshot_dir.path_join(name + ".png")
	_check(root.get_texture().get_image().save_png(path) == OK, "rendered %s review frame saved" % name)
	print("Review frame: " + path)

func _run() -> void:
	root.size = Vector2i(1280, 720)
	# A display-backed test can inherit physically held desktop keys on focus.
	# Start its synthetic movement sequence from a released input state.
	Input.flush_buffered_events()
	for action: StringName in [&"move_left", &"move_right", &"move_forward", &"move_backward", &"sprint"]:
		Input.action_release(action)
	_world = SCENE.instantiate()
	root.add_child(_world)
	_player = _world.get_node("PollingUnit/Player") as PlayerControls
	_visual = _player.get_node("CharacterVisual") as HumanVisual
	_officer = _world.get_node("PollingOfficerPlaceholder/CharacterVisual") as HumanVisual
	_panel = _world.get_node("DialogueLayer/DialoguePanel") as DialogueProvider
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	await _frames(8)
	print("Initial visual states: player=%s, officer=%s, velocity=%s, input=%s." % [_visual.current_animation, _officer.current_animation, _player.velocity, Input.get_vector("move_left", "move_right", "move_forward", "move_backward")])
	var capsule := _player.get_node("CollisionShape3D").shape as CapsuleShape3D
	var officer_shape := _world.get_node("PollingOfficerPlaceholder/Collision").shape as CapsuleShape3D
	_check(is_equal_approx(capsule.radius, 0.5) and is_equal_approx(capsule.height, 2.0), "player capsule dimensions preserved")
	_check(is_equal_approx(officer_shape.radius, 0.35) and is_equal_approx(officer_shape.height, 1.8), "officer capsule dimensions preserved")
	_check(_meshes(_visual).size() == 4 and _meshes(_officer).size() == 4, "both human visuals have four skinned meshes")
	_check(_visual.current_animation == &"idle" and _officer.current_animation == &"idle", "both characters start idle")
	var animator := _animator(_visual)
	var officer_animator := _animator(_officer)
	for clip: StringName in [&"idle", &"walk", &"run"]:
		_check(animator.has_animation(clip), "%s animation imported" % clip)
		_check(animator.get_animation(clip).loop_mode == Animation.LOOP_LINEAR, "%s animation loops" % clip)
	_check(animator.get_animation(&"idle") != officer_animator.get_animation(&"idle"), "animation resources are independent per character")
	var first_mesh := _meshes(_visual)[0] as MeshInstance3D
	var officer_mesh := _meshes(_officer)[0] as MeshInstance3D
	_check(first_mesh.mesh == officer_mesh.mesh, "both characters share imported mesh geometry")
	_check(first_mesh.get_active_material(0) != officer_mesh.get_active_material(0), "character materials are independently tinted")
	var bounds := _bounds(_visual)
	_check(bounds.size.y > 1.75 and bounds.size.y < 1.95, "human model uses metre-scale adult height")
	_check(absf(bounds.position.y) < 0.02, "standing visual feet align with ground")
	_check(_player.camera_pivot.position == Vector3(0.0, 0.6, 0.0) and is_equal_approx(_player.spring_arm.spring_length, 6.0), "camera pivot and arm defaults preserved")

	Input.action_press(&"move_forward")
	await _frames(20)
	_check(_visual.current_animation == &"walk", "actual walking velocity selects walk")
	_check((-_visual.global_basis.z).dot(_player.velocity.normalized()) > 0.95, "visible player faces camera-relative movement")
	Input.action_press(&"sprint")
	await _frames(5)
	_check(_visual.current_animation == &"run", "actual sprint velocity selects run")
	_check(_officer.current_animation == &"idle", "officer stays idle while player runs")
	Input.action_release(&"sprint")
	Input.action_release(&"move_forward")
	await _frames()
	_check(_visual.current_animation == &"idle", "stopping selects idle")

	# Ensure animation sampling does not introduce large foot sinks or hovering.
	_player.global_position = Vector3(1.8, 1.0, 0.0)
	_player.velocity = Vector3.ZERO
	await _frames()
	_visual.set_process(false)
	var min_contact := INF
	var max_contact := -INF
	for clip: StringName in [&"idle", &"walk", &"run"]:
		for sample in range(8):
			animator.play(clip, 0.0)
			animator.seek(animator.get_animation(clip).length * sample / 8.0, true)
			animator.pause()
			await process_frame
			var foot_y := _foot_minimum(_visual)
			min_contact = minf(min_contact, foot_y)
			max_contact = maxf(max_contact, foot_y)
			_check(is_finite(foot_y) and foot_y > -0.07 and foot_y < 0.24, "%s feet stay near ground across sampled frames" % clip)
	print("Sampled animated foot range: %.4f to %.4f metres." % [min_contact, max_contact])
	animator.play(&"idle", 0.0)
	_visual.current_animation = &"idle"
	_visual.set_process(true)
	await _frames()

	# A front review camera is temporary test instrumentation, not a scene edit.
	_visual.rotation.y = PI
	var review_camera := Camera3D.new()
	_world.add_child(review_camera)
	review_camera.global_position = Vector3(2.9, 1.25, 4.8)
	review_camera.look_at(Vector3(2.9, 1.0, 0.0))
	review_camera.fov = 48.0
	review_camera.current = true
	await _frames()
	await _snapshot("characters_front")
	review_camera.queue_free()
	_player.get_node("CameraPivot/SpringArm3D/Camera3D").current = true
	_visual.rotation.y = 0.0
	await _frames()
	_key(KEY_E)
	await _frames()
	_check(_panel.is_conversation_open(), "real officer dialogue opens with new human visuals")
	_check(not _player.is_movement_input_enabled() and _visual.current_animation == &"idle", "dialogue locks movement and presentation becomes idle")
	await _snapshot("characters_dialogue")
	_key(KEY_ESCAPE)
	await _frames()
	_check(not _panel.is_conversation_open() and _player.is_movement_input_enabled(), "Escape closes real dialogue and restores player")

	# Actual canopy post compresses the spring arm into the player's shoulder.
	_player.global_position = Vector3(4.0, 1.0, 3.35)
	_player.velocity = Vector3.ZERO
	_player.camera_pivot.rotation.y = 0.0
	await _frames(8)
	var close_arm := _player.spring_arm.get_hit_length()
	print("Canopy close-camera arm length: %.4f metres." % close_arm)
	_check(close_arm < 0.7, "canopy post shortens camera in actual environment")
	_check(not _visual.get_node("Model").visible, "near camera hides only the player mesh")
	_check(_officer.get_node("Model").visible and _player.get_node("CollisionShape3D").shape != null, "officer and player collision remain active during close-camera hiding")
	await _snapshot("characters_canopy_close")
	_player.global_position = Vector3(0.0, 1.0, 8.0)
	await _frames(8)
	_check(_player.spring_arm.get_hit_length() > 5.5 and _visual.get_node("Model").visible, "normal camera distance restores visible human")
	await _snapshot("characters_third_person")
	print("Human character checks: %d checks, %d failures; display=%s." % [_checks, _failures, DisplayServer.get_name()])
	print("Visual frames and synthetic checks do not prove human input comfort, final cultural design, or sustained hardware frame rate.")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_world.queue_free()
	await process_frame
	quit(0 if _failures == 0 else 1)
