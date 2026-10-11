extends SceneTree
## Offline integration checks against the existing world and the isolated panel.
## Run: godot --headless --path <project> --script res://tests/interaction/interaction_checks.gd

const PlayerControls = preload("res://player.gd")
const Target = preload("res://scripts/interaction/interaction_target.gd")
const PLAYTEST = preload("res://tests/interaction/interaction_playtest.tscn")

var _world: Node3D
var _player: PlayerControls
var _panel: Node
var _controller: Node
var _target: Target
var _opened: Array[StringName] = []
var _closed: Array[StringName] = []
var _responses: Array[Array] = []
var _checks: int = 0
var _failures: int = 0

func _initialize() -> void:
	_run.call_deferred()

func _check(condition: bool, description: String) -> void:
	_checks += 1
	if not condition:
		_failures += 1
		push_error("FAIL: " + description)

func _frames(count: int = 3) -> void:
	for index in range(count):
		await physics_frame
	await process_frame
	await process_frame

func _new_world() -> void:
	if is_instance_valid(_world):
		_world.queue_free()
		await process_frame
	_world = PLAYTEST.instantiate()
	root.add_child(_world)
	_player = _world.get_node("PollingUnit/Player") as PlayerControls
	_panel = _world.get_node("DialoguePanelSubstitute")
	_controller = _world.get_node("InteractionController")
	_target = _world.get_node("PollingOfficerPlaceholder") as Target
	_panel.connect(&"conversation_opened", func(id: StringName) -> void: _opened.append(id))
	_panel.connect(&"conversation_closed", func(id: StringName) -> void: _closed.append(id))
	_panel.connect(&"response_selected", func(id: StringName, node: StringName, response: StringName) -> void:
		_responses.append([id, node, response]))
	await _frames()

func _key(code: Key, pressed: bool = true, echo: bool = false) -> bool:
	var event := InputEventKey.new()
	event.physical_keycode = code
	event.pressed = pressed
	event.echo = echo
	root.push_input(event, true)
	return root.is_input_handled()

func _approach() -> void:
	_player.global_position = Vector3(2.0, 1.0, 0.0)
	_player.velocity = Vector3.ZERO
	await _frames()

func _open_from_world() -> void:
	_key(KEY_E)
	_key(KEY_E, false)
	await _frames()

func _close() -> void:
	_panel.call(&"close_conversation")
	await _frames()

func _run() -> void:
	await _new_world()
	_check(InputMap.has_action(&"interact"), "named interact action exists")
	var e_binding := false
	for event in InputMap.action_get_events(&"interact"):
		if event is InputEventKey and event.physical_keycode == KEY_E:
			e_binding = true
	_check(e_binding, "interact uses physical E")
	_check(_player.is_movement_input_enabled() and _player.is_look_input_enabled(), "baseline controls enabled")
	_check(not _panel.call(&"open_conversation", &"unknown"), "unknown conversation rejected")
	_check(_opened.is_empty() and not _panel.call(&"is_conversation_open"), "unknown conversation emits no open")
	_key(KEY_E)
	await _frames()
	_check(_opened.is_empty(), "entrance is outside interaction range")
	_check(not _controller.get_node("HUD/Prompt").visible, "prompt hidden outside range")

	# Existing movement, solid perimeter and SpringArm behavior.
	_player.global_position = Vector3(0.0, 1.0, 8.0)
	Input.action_press(&"move_forward")
	await _frames()
	_check(is_equal_approx(_player.velocity.z, -5.0), "camera-relative walking still uses walk speed")
	Input.action_press(&"sprint")
	await _frames()
	_check(is_equal_approx(_player.velocity.z, -8.0), "Shift sprint speed preserved")
	Input.action_release(&"move_forward")
	Input.action_release(&"sprint")
	_player.camera_pivot.rotation.y = PI / 2.0
	Input.action_press(&"move_forward")
	await _frames()
	_check(_player.velocity.x < -4.9 and absf(_player.velocity.z) < 0.1, "walking follows camera horizontal yaw")
	Input.action_release(&"move_forward")
	_player.camera_pivot.rotation.y = 0.0
	_player.global_position = Vector3(14.6, 1.0, 7.0)
	_player.velocity = Vector3.ZERO
	Input.action_press(&"move_right")
	await _frames(40)
	Input.action_release(&"move_right")
	_check(_player.global_position.x > 14.8 and _player.global_position.x < 15.5, "solid perimeter still stops player")
	_player.global_position = Vector3(0.0, 1.0, 2.0)
	await _frames()
	_check(_player.spring_arm.get_hit_length() > 5.8, "spring arm excludes player in clear space")
	_player.global_position = Vector3(12.0, 1.0, 13.0)
	await _frames()
	_check(_player.spring_arm.get_hit_length() < 3.0, "spring arm shortens at perimeter wall")

	await _approach()
	_check(_controller.get_node("HUD/Prompt").visible, "reachable target shows prompt")
	_target.enabled = false
	await _frames()
	await _open_from_world()
	_check(not _panel.call(&"is_conversation_open"), "disabled target cannot open")
	_target.enabled = true
	_target.conversation_id = &"unknown"
	await _open_from_world()
	_check(not _panel.call(&"is_conversation_open"), "failed provider lookup leaves panel closed")
	_check(_player.is_movement_input_enabled() and _player.is_look_input_enabled(), "failed open does not lock controls")
	_target.conversation_id = &"polling_officer_intro"

	# Nearest target wins, and solid obstacles obstruct interaction.
	var closer := Target.new()
	closer.display_name = "Closer test marker"
	closer.conversation_id = &"unknown"
	closer.position = Vector3(2.0, 0.0, 1.0)
	_world.add_child(closer)
	await _frames()
	_check("Closer test marker" in _controller.get_node("HUD/Prompt").text, "prompt chooses nearest reachable target")
	await _open_from_world()
	_check(not _panel.call(&"is_conversation_open"), "nearest target ID requested instead of farther valid ID")
	closer.queue_free()
	await _frames()
	var obstruction := StaticBody3D.new()
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(0.3, 3.0, 3.0)
	collision.shape = shape
	obstruction.add_child(collision)
	obstruction.position = Vector3(2.9, 1.5, 0.0)
	_world.add_child(obstruction)
	await _frames()
	await _open_from_world()
	_check(not _panel.call(&"is_conversation_open"), "wall blocks interaction ray")
	obstruction.queue_free()
	await _frames()
	_key(KEY_E)
	_target.position.x = 10.0
	await _frames()
	_check(not _panel.call(&"is_conversation_open"), "range rechecked after opening request deferral")
	_target.position.x = 3.8
	await _frames()

	# Successful open owns input only after the provider succeeds.
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var initial_open_count := _opened.size()
	Input.action_press(&"ui_accept")
	_check(_key(KEY_E), "opening E consumed")
	_key(KEY_E, false)
	await _frames()
	_check(_panel.call(&"is_conversation_open"), "shared test conversation opened")
	_check(_opened.size() == initial_open_count + 1 and _opened.back() == &"polling_officer_intro", "opened signal uses stable shared ID once")
	_check(_responses.is_empty(), "opening E did not select a response")
	_panel.get_node("Panel/Margin/Content/ResponseButton").pressed.emit()
	_check(_responses.is_empty(), "held accept at open cannot select a response")
	Input.action_release(&"ui_accept")
	await _frames()
	_check(not _player.is_movement_input_enabled() and not _player.is_look_input_enabled(), "successful open locks movement and look")
	_check(not _panel.call(&"open_conversation", &"polling_officer_intro"), "provider rejects open while active")
	_key(KEY_E, true, true)
	_key(KEY_E)
	await _frames()
	_check(_opened.size() == initial_open_count + 1 and _responses.is_empty(), "held or repeated E cannot reopen or select")
	var yaw := _player.camera_pivot.rotation.y
	var pitch := _player.spring_arm.rotation.x
	var motion := InputEventMouseMotion.new()
	motion.screen_relative = Vector2(2000.0, 2000.0)
	root.push_input(motion)
	_check(is_equal_approx(_player.camera_pivot.rotation.y, yaw) and is_equal_approx(_player.spring_arm.rotation.x, pitch), "locked mouse motion does not rotate camera")
	_player.global_position.y = 8.0
	_player.velocity = Vector3(5.0, 0.0, 5.0)
	var position_before := _player.global_position
	Input.action_press(&"move_forward")
	await _frames(12)
	Input.action_release(&"move_forward")
	_check(_player.global_position.y < position_before.y and _player.velocity.y < 0.0, "gravity continues during dialogue")
	_check(is_equal_approx(_player.global_position.x, position_before.x) and is_equal_approx(_player.global_position.z, position_before.z), "locked player has no horizontal movement")
	_player.global_position.y = -12.0
	await _frames()
	_check(_player.global_position.distance_to(Vector3(0.0, 1.0, 0.0)) < 0.2, "falling-off-map respawn runs while locked")
	var close_count := _closed.size()
	_check(_key(KEY_ESCAPE), "active Escape consumed")
	_key(KEY_ESCAPE, false)
	await _frames()
	_check(not _panel.call(&"is_conversation_open") and _closed.size() == close_count + 1, "Escape closes once")
	_check(_player.is_movement_input_enabled() and _player.is_look_input_enabled(), "Escape restores gameplay inputs")
	_check(Input.mouse_mode == Input.MOUSE_MODE_VISIBLE, "visible mouse state restored")
	await _close()
	_check(_closed.size() == close_count + 1, "repeated close does nothing")
	await _approach()
	await _open_from_world()
	_world.move_child(_controller, 0)
	_check(_key(KEY_ESCAPE), "Escape consumed when panel receives input before controller")
	await _frames()
	_check(not _panel.call(&"is_conversation_open") and _player.is_movement_input_enabled(), "panel-first close safely restores controls")

	# Restore independently disabled input states rather than enabling everything.
	await _approach()
	_player.set_gameplay_input_enabled(false, true)
	await _open_from_world()
	await _close()
	_check(not _player.is_movement_input_enabled() and _player.is_look_input_enabled(), "prior movement-disabled state restored")
	_player.set_gameplay_input_enabled(true, false)
	await _open_from_world()
	await _close()
	_check(_player.is_movement_input_enabled() and not _player.is_look_input_enabled(), "prior look-disabled state restored")
	_player.set_gameplay_input_enabled(true, true)
	_panel.call(&"open_conversation", &"polling_officer_intro")
	await _open_from_world()
	_check(_player.is_movement_input_enabled() and _player.is_look_input_enabled(), "externally active panel does not grant control ownership")
	await _close()
	var synchronous_close := func(_id: StringName) -> void: _panel.call(&"close_conversation")
	_panel.connect(&"conversation_opened", synchronous_close)
	await _open_from_world()
	_check(not _panel.call(&"is_conversation_open") and _player.is_movement_input_enabled(), "synchronous close during open does not lock gameplay")
	_panel.disconnect(&"conversation_opened", synchronous_close)

	await _open_from_world()
	var response_count := _responses.size()
	close_count = _closed.size()
	var response_button: Button = _panel.get_node("Panel/Margin/Content/ResponseButton")
	_check(response_button.has_focus(), "test panel owns initial response focus")
	response_button.pressed.emit()
	response_button.pressed.emit()
	await _frames()
	_check(_responses.size() == response_count + 1, "duplicate response signals accepted once")
	_check(_responses.back() == [&"polling_officer_intro", &"intro", &"test_response"], "response signal uses stable conversation/node/response IDs")
	_check(_closed.size() == close_count + 1 and not _panel.call(&"is_conversation_open"), "natural ending closes once")
	_check(_player.is_movement_input_enabled() and _player.is_look_input_enabled(), "natural ending restores controls")

	# Lifetime cases must not leave gameplay locked or open obsolete targets.
	_key(KEY_E)
	_target.free()
	await _frames()
	_check(not _panel.call(&"is_conversation_open") and _player.is_movement_input_enabled(), "target freed before deferred open is ignored")
	await _new_world()
	await _approach()
	await _open_from_world()
	_target.queue_free()
	await _frames()
	_key(KEY_ESCAPE)
	await _frames()
	_check(not _panel.call(&"is_conversation_open") and _player.is_movement_input_enabled(), "target removal during dialogue still allows close")
	await _new_world()
	await _approach()
	await _open_from_world()
	_panel.queue_free()
	await _frames()
	_check(_player.is_movement_input_enabled() and _player.is_look_input_enabled(), "provider removal restores controls")
	await _new_world()
	await _approach()
	await _open_from_world()
	_controller.queue_free()
	await _frames()
	_check(not _panel.call(&"is_conversation_open") and _player.is_movement_input_enabled(), "controller removal closes panel and restores controls")

	print("Interaction checks: %d checks, %d failures." % [_checks, _failures])
	print("Headless limits: actual pointer capture/restoration, camera pitch input, visual layout and UI navigation require windowed playtesting.")
	_world.queue_free()
	await process_frame
	quit(0 if _failures == 0 else 1)
