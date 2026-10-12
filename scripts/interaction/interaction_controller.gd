extends Node

## Owns target selection and gameplay controls, never dialogue content or rewards.
const PlayerControls = preload("res://player.gd")
const Target = preload("res://scripts/interaction/interaction_target.gd")

@export var player_path: NodePath
@export var dialogue_panel_path: NodePath
@export_range(0.5, 8.0, 0.1) var interaction_range: float = 3.0
@export_flags_3d_physics var collision_mask: int = 1

@onready var _prompt: Label = $HUD/Prompt

var _player: PlayerControls
var _panel: Node
var _opening_pending: bool = false
var _request_in_progress: bool = false
var _closed_during_request: bool = false
var _requested_id: StringName
var _active_id: StringName
var _owns_controls: bool = false
var _saved_movement_enabled: bool
var _saved_look_enabled: bool
var _saved_mouse_mode: Input.MouseMode

func _ready() -> void:
	_player = get_node_or_null(player_path) as PlayerControls
	_panel = get_node_or_null(dialogue_panel_path)
	if not is_instance_valid(_player) or not _has_panel_interface():
		push_error("InteractionController needs a player and a contract-v1 dialogue panel.")
		set_process(false)
		set_process_input(false)
		set_process_unhandled_input(false)
		return
	_panel.connect(&"conversation_closed", _on_conversation_closed)
	_panel.tree_exiting.connect(_on_panel_tree_exiting)

func _has_panel_interface() -> bool:
	if not is_instance_valid(_panel):
		return false
	for method in [&"open_conversation", &"close_conversation", &"is_conversation_open"]:
		if not _panel.has_method(method):
			return false
	for signal_name in [&"conversation_opened", &"response_selected", &"conversation_closed"]:
		if not _panel.has_signal(signal_name):
			return false
	return true

func _process(_delta: float) -> void:
	_prompt.hide()
	if not is_instance_valid(_player) or not is_instance_valid(_panel):
		return
	if _owns_controls or _opening_pending or _panel.call(&"is_conversation_open"):
		return
	var target := _find_target()
	if target != null:
		_prompt.text = "Press E to interact — %s" % target.display_name
		_prompt.show()

func _input(event: InputEvent) -> void:
	# This runs before the player's _unhandled_input and consumes Escape before
	# closing can restore gameplay. UI focus/navigation belongs to the panel.
	if _owns_controls and event.is_action_pressed(&"release_mouse"):
		get_viewport().set_input_as_handled()
		if is_instance_valid(_panel):
			_panel.call(&"close_conversation")

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed(&"interact") or event.is_echo():
		return
	if _owns_controls or _opening_pending:
		get_viewport().set_input_as_handled()
		return
	if not is_instance_valid(_panel) or _panel.call(&"is_conversation_open"):
		return
	var target := _find_target()
	if target == null:
		return
	get_viewport().set_input_as_handled()
	_opening_pending = true
	# Finish dispatching the opening event before exposing any dialogue buttons.
	_try_open.call_deferred(target)

func _find_target() -> Target:
	var nearest: Target
	var nearest_distance: float = interaction_range * interaction_range
	for node in get_tree().get_nodes_in_group(&"interaction_targets"):
		var target := node as Target
		if not _is_reachable(target):
			continue
		var distance := _interaction_origin().distance_squared_to(target.get_interaction_position())
		if distance <= nearest_distance:
			nearest = target
			nearest_distance = distance
	return nearest

func _interaction_origin() -> Vector3:
	return _player.global_position + Vector3.UP

func _is_reachable(target: Target) -> bool:
	if not is_instance_valid(_player) or not is_instance_valid(target):
		return false
	if not target.is_inside_tree() or not target.enabled or target.conversation_id == &"":
		return false
	var origin := _interaction_origin()
	var destination := target.get_interaction_position()
	if origin.distance_squared_to(destination) > interaction_range * interaction_range:
		return false
	var query := PhysicsRayQueryParameters3D.create(origin, destination, collision_mask, [_player.get_rid()])
	var hit := _player.get_world_3d().direct_space_state.intersect_ray(query)
	if hit.is_empty():
		return true
	var collider: Node = hit["collider"] as Node
	return collider == target or target.is_ancestor_of(collider)

func _try_open(candidate: Variant) -> void:
	_opening_pending = false
	# A deferred call may carry an object freed since the E press. Validate the
	# Variant before casting, so Godot does not reject a freed typed argument.
	if not is_instance_valid(candidate):
		return
	var target := candidate as Target
	# Recheck after deferral: walking away, a removed target, or another active
	# panel must not allow an outdated prompt to start a conversation.
	if _owns_controls or not is_instance_valid(_panel) or not _is_reachable(target):
		return
	if _panel.call(&"is_conversation_open"):
		return
	var movement_enabled := _player.is_movement_input_enabled()
	var look_enabled := _player.is_look_input_enabled()
	var mouse_mode := Input.mouse_mode
	_requested_id = target.conversation_id
	_closed_during_request = false
	_request_in_progress = true
	var opened: bool = _panel.call(&"open_conversation", _requested_id)
	_request_in_progress = false
	if not opened or _closed_during_request or not is_instance_valid(_panel):
		return
	if not is_inside_tree() or is_queued_for_deletion() or _panel.is_queued_for_deletion():
		return
	if not is_instance_valid(_player) or not _player.is_inside_tree() or _player.is_queued_for_deletion():
		return
	if not _panel.call(&"is_conversation_open"):
		return
	_saved_movement_enabled = movement_enabled
	_saved_look_enabled = look_enabled
	_saved_mouse_mode = mouse_mode
	_active_id = _requested_id
	_owns_controls = true
	_player.set_gameplay_input_enabled(false, false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_prompt.hide()

func _on_conversation_closed(conversation_id: StringName) -> void:
	if _request_in_progress and conversation_id == _requested_id:
		_closed_during_request = true
	if _owns_controls and conversation_id == _active_id:
		# Also covers a panel handling Escape first. Keep the player locked until
		# this input dispatch ends, then restore exactly the saved state.
		_restore_gameplay_state.call_deferred()

func _on_panel_tree_exiting() -> void:
	_restore_gameplay_state.call_deferred()
	_prompt.hide()
	# A detached provider must not accept further interaction requests.
	_panel = null

func _restore_gameplay_state() -> void:
	if not _owns_controls:
		return
	_owns_controls = false
	if is_instance_valid(_player):
		_player.set_gameplay_input_enabled(_saved_movement_enabled, _saved_look_enabled)
	Input.mouse_mode = _saved_mouse_mode
	_active_id = &""

func _exit_tree() -> void:
	if _owns_controls and is_instance_valid(_panel) and _panel.is_inside_tree():
		_panel.call(&"close_conversation")
	_restore_gameplay_state()
