extends Node3D
## Provisional civilian presentation only: the parent body owns input and physics.

@export var locomotion_enabled: bool = true
@export var hide_when_camera_close: bool = false
@export_range(0.0, 0.5, 0.01) var animation_blend_time: float = 0.12
@export_range(1.0, 30.0, 0.5) var facing_turn_speed: float = 12.0
@export var skin_color: Color = Color(0.34, 0.20, 0.12, 1.0)
@export var hair_color: Color = Color(0.045, 0.035, 0.027, 1.0)
@export var shirt_color: Color = Color(0.24, 0.37, 0.40, 1.0)
@export var trousers_color: Color = Color(0.20, 0.24, 0.28, 1.0)
@export var shoe_color: Color = Color(0.08, 0.085, 0.08, 1.0)

const MOVEMENT_THRESHOLD: float = 0.08
const RUN_THRESHOLD: float = 6.5
const CAMERA_HIDE_DISTANCE: float = 0.70
const CAMERA_SHOW_DISTANCE: float = 0.95
const EYE_OFFSET: Vector3 = Vector3(0.0, 1.55, 0.0)

var current_animation: StringName = &""
var _body: CharacterBody3D
var _animation_player: AnimationPlayer
var _animation_names: Dictionary[StringName, StringName] = {}
var _camera_model_hidden: bool = false

@onready var _model: Node3D = $Model


func _ready() -> void:
	_body = _find_body()
	_animation_player = _find_animation_player(_model)
	_apply_palette(_model)
	if _animation_player == null:
		push_warning("Civilian visual has no AnimationPlayer; its model remains static.")
	else:
		_make_animations_local()
		for animation_id: StringName in [&"idle", &"walk", &"run"]:
			_animation_names[animation_id] = _find_animation_name(animation_id)
			if _animation_names[animation_id] == &"":
				push_warning("Civilian visual is missing the %s animation." % animation_id)
		_play_animation(&"idle")
	_update_camera_visibility()


func _process(delta: float) -> void:
	var horizontal_velocity := Vector3.ZERO
	if locomotion_enabled and is_instance_valid(_body):
		horizontal_velocity = Vector3(_body.velocity.x, 0.0, _body.velocity.z)
		# Dialogue locks clear horizontal velocity, but also respect a saved lock
		# while the body is being carried or moved by necessary physics.
		if _body.has_method("is_movement_input_enabled"):
			if not bool(_body.call("is_movement_input_enabled")):
				horizontal_velocity = Vector3.ZERO

	var speed := horizontal_velocity.length()
	if speed < MOVEMENT_THRESHOLD:
		_play_animation(&"idle")
	else:
		_play_animation(&"run" if speed > RUN_THRESHOLD else &"walk")
		_face_velocity(horizontal_velocity, delta)
	_update_camera_visibility()


func _find_body() -> CharacterBody3D:
	var ancestor := get_parent()
	while ancestor != null:
		if ancestor is CharacterBody3D:
			return ancestor as CharacterBody3D
		ancestor = ancestor.get_parent()
	return null


func _find_animation_player(node: Node) -> AnimationPlayer:
	if node is AnimationPlayer:
		return node as AnimationPlayer
	for child: Node in node.get_children():
		var found := _find_animation_player(child)
		if found != null:
			return found
	return null


func _make_animations_local() -> void:
	# Imported resources are shared. Give each character its own libraries before
	# setting loop modes so neither character changes the other's playback.
	for library_name: StringName in _animation_player.get_animation_library_list():
		var source_library := _animation_player.get_animation_library(library_name)
		var local_library := AnimationLibrary.new()
		local_library.resource_local_to_scene = true
		for animation_name: StringName in source_library.get_animation_list():
			var local_animation := source_library.get_animation(animation_name).duplicate(true) as Animation
			local_animation.resource_local_to_scene = true
			if animation_name in [&"idle", &"walk", &"run"]:
				local_animation.loop_mode = Animation.LOOP_LINEAR
			local_library.add_animation(animation_name, local_animation)
		_animation_player.remove_animation_library(library_name)
		_animation_player.add_animation_library(library_name, local_library)


func _find_animation_name(animation_id: StringName) -> StringName:
	for animation_name: StringName in _animation_player.get_animation_list():
		if animation_name == animation_id or String(animation_name).ends_with("/" + String(animation_id)):
			return animation_name
	return &""


func _play_animation(animation_id: StringName) -> void:
	if _animation_player == null or current_animation == animation_id:
		return
	var animation_name: StringName = _animation_names.get(animation_id, &"")
	if animation_name == &"":
		return
	_animation_player.play(animation_name, animation_blend_time)
	current_animation = animation_id


func _face_velocity(world_velocity: Vector3, delta: float) -> void:
	var local_velocity := world_velocity
	var visual_parent := get_parent() as Node3D
	if visual_parent != null:
		local_velocity = visual_parent.global_basis.inverse() * world_velocity
	local_velocity.y = 0.0
	# Model's source front is +Z; its child wrapper turns that front to -Z.
	# Turn only this visual root, leaving the physics body and camera untouched.
	var desired_yaw := atan2(-local_velocity.x, -local_velocity.z)
	rotation.y = lerp_angle(rotation.y, desired_yaw, minf(facing_turn_speed * delta, 1.0))


func _apply_palette(node: Node) -> void:
	if node is MeshInstance3D:
		var mesh_instance := node as MeshInstance3D
		if mesh_instance.mesh != null:
			for surface: int in range(mesh_instance.mesh.get_surface_count()):
				var source_material := mesh_instance.get_active_material(surface) as StandardMaterial3D
				if source_material == null:
					continue
				var local_material := source_material.duplicate(true) as StandardMaterial3D
				local_material.resource_local_to_scene = true
				match source_material.resource_name:
					"Skin":
						local_material.albedo_color = skin_color
					"Skin_Darker":
						local_material.albedo_color = skin_color.darkened(0.15)
					"Hair", "Eyebrows":
						local_material.albedo_color = hair_color
					"Eye":
						local_material.albedo_color = Color(0.10, 0.075, 0.05, 1.0)
					"LightBrown":
						local_material.albedo_color = shirt_color
					"LightBlue":
						local_material.albedo_color = trousers_color
					"Red_Dark":
						local_material.albedo_color = shoe_color
					"White":
						local_material.albedo_color = Color(0.30, 0.31, 0.29, 1.0)
				local_material.roughness = 0.90
				mesh_instance.set_surface_override_material(surface, local_material)
	for child: Node in node.get_children():
		_apply_palette(child)


func _update_camera_visibility() -> void:
	if not hide_when_camera_close:
		if _camera_model_hidden:
			_model.visible = true
			_camera_model_hidden = false
		return
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		_model.visible = true
		_camera_model_hidden = false
		return
	var camera_distance := camera.global_position.distance_to(to_global(EYE_OFFSET))
	if not _camera_model_hidden and camera_distance < CAMERA_HIDE_DISTANCE:
		_model.visible = false
		_camera_model_hidden = true
	elif _camera_model_hidden and camera_distance > CAMERA_SHOW_DISTANCE:
		_model.visible = true
		_camera_model_hidden = false
