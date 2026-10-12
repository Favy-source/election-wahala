extends SceneTree
## Combined controller, real dialogue panel and player regression checks.
## Run headless first. A display-backed run additionally checks captured mouse.

const WORLD = preload("res://tests/integration/interaction_dialogue_playtest.tscn")
const PlayerControls = preload("res://player.gd")
const DialogueProvider = preload("res://scripts/dialogue/dialogue_panel.gd")
const Target = preload("res://scripts/interaction/interaction_target.gd")
const ID: StringName = &"polling_officer_intro"
const ROUTES: Array = [
	[&"here_to_vote", &"will_wait", &"end_conversation"],
	[&"here_to_vote", &"come_back_later", &"end_conversation"],
	[&"ask_unit", &"here_to_vote", &"will_wait", &"end_conversation"],
	[&"ask_unit", &"here_to_vote", &"come_back_later", &"end_conversation"],
	[&"just_passing", &"end_conversation"],
	[&"ask_unit", &"just_passing", &"end_conversation"],
]

class GameplayEscapeProbe extends Node:
	var presses: int = 0
	func _unhandled_input(event: InputEvent) -> void:
		if event.is_action_pressed(&"release_mouse"):
			presses += 1

var _world: Node3D
var _player: PlayerControls
var _panel: DialogueProvider
var _controller: Node
var _target: Target
var _probe: GameplayEscapeProbe
var _opened: Array[StringName] = []
var _closed: Array[StringName] = []
var _selected: Array[Array] = []
var _events: Array[Array] = []
var _checks: int = 0
var _failures: int = 0
var _capture_checks: int = 0
var _data: Dictionary
var _snapshot_path: String = ""
var _snapshot_saved: bool = false

func _initialize() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--snapshot="):
			_snapshot_path = argument.trim_prefix("--snapshot=")
	_run.call_deferred()

func _check(condition: bool, description: String) -> void:
	_checks += 1
	if not condition:
		_failures += 1
		push_error("FAIL: " + description)

func _frames(count: int = 2) -> void:
	for index in range(count):
		await process_frame

func _physics(count: int = 3) -> void:
	for index in range(count):
		await physics_frame
	await _frames()

func _new_world() -> void:
	if is_instance_valid(_world):
		_world.queue_free()
		await _frames()
	_world = WORLD.instantiate()
	root.add_child(_world)
	_player = _world.get_node("PollingUnit/Player") as PlayerControls
	_panel = _world.get_node("DialogueLayer/DialoguePanel") as DialogueProvider
	_controller = _world.get_node("InteractionController")
	_target = _world.get_node("PollingOfficerPlaceholder") as Target
	_probe = GameplayEscapeProbe.new()
	_world.add_child(_probe)
	_panel.conversation_opened.connect(func(id: StringName) -> void:
		_opened.append(id)
		_events.append([&"opened", id]))
	_panel.response_selected.connect(func(id: StringName, node: StringName, response: StringName) -> void:
		_selected.append([id, node, response])
		_events.append([&"selected", id, node, response]))
	_panel.conversation_closed.connect(func(id: StringName) -> void:
		_closed.append(id)
		_events.append([&"closed", id]))
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	await _physics()

func _key(code: Key, pressed: bool = true, echo: bool = false, shift: bool = false) -> bool:
	var event := InputEventKey.new()
	event.keycode = code
	event.physical_keycode = code
	event.pressed = pressed
	event.echo = echo
	event.shift_pressed = shift
	root.push_input(event, true)
	return root.is_input_handled()

func _mouse(position: Vector2, pressed: bool, double_click: bool = false) -> void:
	var event := InputEventMouseButton.new()
	event.position = position
	event.global_position = position
	event.button_index = MOUSE_BUTTON_LEFT
	event.button_mask = MOUSE_BUTTON_MASK_LEFT if pressed else 0
	event.pressed = pressed
	event.double_click = double_click
	root.push_input(event, true)

func _buttons() -> Array[Node]:
	return _panel.get_node("%ResponseList").get_children()

func _button(id: StringName) -> Button:
	return _panel.get_node_or_null("%%ResponseList/Response_%s" % id) as Button

func _tap(code: Key, shift: bool = false) -> void:
	_key(code, true, false, shift)
	_key(code, false, false, shift)
	await _frames()

func _approach() -> void:
	_player.global_position = Vector3(2.0, 1.0, 0.0)
	_player.velocity = Vector3.ZERO
	await _physics()

func _open() -> void:
	var previous_selections := _selected.size()
	var previous_opens := _opened.size()
	_check(_key(KEY_E), "opening E consumed by interaction controller")
	_key(KEY_E, false)
	await _frames(3)
	_check(_panel.is_conversation_open(), "controller opens real conversation")
	_check(_opened.size() == previous_opens + 1 and _opened.back() == ID, "real panel opens once with shared ID")
	_check(_selected.size() == previous_selections, "opening E chooses no response")
	_check(not _player.is_movement_input_enabled() and not _player.is_look_input_enabled(), "real successful open locks movement and look")
	_check(Input.mouse_mode == Input.MOUSE_MODE_VISIBLE, "dialogue makes mouse visible")
	if not _snapshot_saved and not _snapshot_path.is_empty() and DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		var result := root.get_texture().get_image().save_png(_snapshot_path)
		_check(result == OK, "optional rendered preview saved")
		_snapshot_saved = true
		print("Rendered dialogue preview: " + _snapshot_path)

func _close() -> void:
	_panel.close_conversation()
	await _frames()

func _route(route: Array, mouse_mode: Input.MouseMode = Input.MOUSE_MODE_VISIBLE) -> void:
	await _approach()
	_player.set_gameplay_input_enabled(true, true)
	Input.mouse_mode = mouse_mode
	var actual_mouse_mode := Input.mouse_mode
	var event_start := _events.size()
	var selection_start := _selected.size()
	var close_start := _closed.size()
	await _open()
	var node_id: StringName = StringName(_data.start_node)
	for response_id: StringName in route:
		var button := _button(response_id)
		_check(button != null, "route response %s/%s exists" % [node_id, response_id])
		if button == null:
			await _close()
			return
		var selections_before := _selected.size()
		button.grab_focus()
		await _tap(KEY_ENTER)
		_check(_selected.size() == selections_before + 1, "keyboard route response accepted once")
		if _selected.size() <= selections_before:
			await _close()
			return
		_check(_selected.back() == [ID, node_id, response_id], "route emits stable conversation/node/response IDs")
		var response_data: Dictionary = {}
		for response: Dictionary in _data.nodes[String(node_id)].responses:
			if response.id == String(response_id):
				response_data = response
				break
		if response_data.get("end") == true:
			_check(not _panel.is_conversation_open(), "ending response closes real panel")
		else:
			node_id = StringName(response_data.next)
			_check(_panel.is_conversation_open() and not _player.is_movement_input_enabled(), "intermediate node keeps gameplay locked")
	_check(_selected.size() == selection_start + route.size(), "whole route emits one selection per response")
	_check(_closed.size() == close_start + 1, "natural completion closes exactly once")
	_check(_events[event_start][0] == &"opened" and _events.back() == [&"closed", ID], "route signal order starts opened and ends closed")
	_check(_player.is_movement_input_enabled() and _player.is_look_input_enabled(), "natural completion restores controls")
	_check(Input.mouse_mode == actual_mouse_mode, "natural completion restores previous mouse state")
	if actual_mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_capture_checks += 1
	_panel.close_conversation()
	await _frames()
	_check(_closed.size() == close_start + 1, "close after natural ending emits nothing")

func _test_keyboard_and_focus() -> void:
	await _approach()
	await _open()
	_check(root.gui_get_focus_owner() == _button(&"here_to_vote"), "first response owns keyboard focus")
	await _tap(KEY_UP)
	_check(root.gui_get_focus_owner() == _button(&"just_passing"), "Up wraps first response to last")
	await _tap(KEY_DOWN)
	_check(root.gui_get_focus_owner() == _button(&"here_to_vote"), "Down wraps last response to first")
	await _tap(KEY_TAB)
	_check(root.gui_get_focus_owner() == _button(&"ask_unit"), "Tab navigates responses")
	await _tap(KEY_TAB, true)
	_check(root.gui_get_focus_owner() == _button(&"here_to_vote"), "Shift Tab navigates back")
	var selection_start := _selected.size()
	var open_start := _opened.size()
	for index in range(4):
		_key(KEY_E, true, true)
		await _frames()
	_check(_opened.size() == open_start and _selected.size() == selection_start, "held E cannot reopen or select")
	_key(KEY_ENTER)
	for index in range(4):
		_key(KEY_ENTER, true, true)
		await _frames()
	_check(_selected.size() == selection_start, "held Enter and echoes do not select before release")
	_key(KEY_ENTER, false)
	await _frames()
	_check(_selected.size() == selection_start + 1, "held Enter released accepts once")
	for index in range(4):
		_key(KEY_ENTER, true, true)
		_key(KEY_ENTER, false)
		await _frames()
	_check(_selected.size() == selection_start + 1, "echo and repeated release cannot choose next node")
	await _tap(KEY_SPACE)
	_check(_selected.size() == selection_start + 2, "fresh Space selects focused response once")
	await _close()
	for keycode: Key in [KEY_ENTER, KEY_SPACE]:
		_key(keycode)
		await _open()
		selection_start = _selected.size()
		for index in range(3):
			_key(keycode, true, true)
			await _frames()
		_key(keycode, false)
		await _frames()
		_check(_selected.size() == selection_start, "held accept before opening and its release select nothing")
		await _close()

func _test_mouse() -> void:
	await _open()
	var selection_start := _selected.size()
	var point := _button(&"here_to_vote").get_global_rect().get_center()
	_check(_button(&"here_to_vote").get_global_rect().has_area(), "click target has laid-out rectangle")
	_mouse(point, true)
	for index in range(3):
		_mouse(point, true, true)
		await _frames()
	_check(_selected.size() == selection_start, "held/repeated click presses select nothing before release")
	_mouse(point, false)
	await _frames()
	_check(_selected.size() == selection_start + 1, "held click release selects once")
	if _button(&"will_wait") != null:
		point = _button(&"will_wait").get_global_rect().get_center()
		for index in range(3):
			_mouse(point, false)
			await _frames()
		_check(_selected.size() == selection_start + 1, "repeated click release cannot choose next node")
		_mouse(point, true)
		_mouse(point, false)
		await _frames()
		_check(_selected.size() == selection_start + 2, "fresh click accepts next response once")
	await _close()
	_mouse(Vector2(400.0, 400.0), true)
	await _open()
	selection_start = _selected.size()
	point = _button(&"here_to_vote").get_global_rect().get_center()
	_mouse(point, false)
	await _frames()
	_check(_selected.size() == selection_start, "click held before opening cannot release-select first response")
	await _close()

func _test_escape_and_restore() -> void:
	var original_index := _controller.get_index()
	for panel_first: bool in [false, true]:
		_world.move_child(_controller, 0 if panel_first else original_index)
		for state: Vector2i in [Vector2i(1, 1), Vector2i(0, 1), Vector2i(1, 0), Vector2i(0, 0)]:
			_player.set_gameplay_input_enabled(bool(state.x), bool(state.y))
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			await _open()
			var escapes_before := _probe.presses
			var closed_before := _closed.size()
			_check(_key(KEY_ESCAPE), "dialogue Escape is consumed in either input order")
			_key(KEY_ESCAPE, false)
			await _frames()
			_check(_probe.presses == escapes_before, "dialogue Escape never reaches gameplay handler")
			_check(not _panel.is_conversation_open() and _closed.size() == closed_before + 1, "Escape closes once")
			_check(_player.is_movement_input_enabled() == bool(state.x) and _player.is_look_input_enabled() == bool(state.y), "Escape restores independently saved movement/look")
			_check(Input.mouse_mode == Input.MOUSE_MODE_VISIBLE, "Escape restores previously visible mouse")
			_key(KEY_ESCAPE, true, true)
			await _frames()
			_check(_closed.size() == closed_before + 1 and _probe.presses == escapes_before, "held Escape echo cannot close twice or reach gameplay")
	_world.move_child(_controller, original_index)
	_player.set_gameplay_input_enabled(true, true)
	var escape_start := _probe.presses
	_key(KEY_ESCAPE)
	await _frames()
	_check(_probe.presses == escape_start + 1, "fresh Escape works normally after dialogue ends")
	_check(Input.mouse_mode == Input.MOUSE_MODE_VISIBLE, "normal gameplay Escape releases mouse")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		await _open()
		_key(KEY_ESCAPE)
		_key(KEY_ESCAPE, false)
		await _frames()
		_check(Input.mouse_mode == Input.MOUSE_MODE_CAPTURED, "dialogue Escape restores captured mouse without gameplay Escape")
		_capture_checks += 1
		await _route(ROUTES[0], Input.MOUSE_MODE_CAPTURED)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		_mouse(Vector2(400.0, 400.0), true)
		_mouse(Vector2(400.0, 400.0), false)
		await _frames()
		_check(Input.mouse_mode == Input.MOUSE_MODE_CAPTURED, "gameplay click recaptures mouse after close")
		_capture_checks += 1
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _test_physics_and_failure() -> void:
	await _approach()
	await _open()
	var yaw := _player.camera_pivot.rotation.y
	var pitch := _player.spring_arm.rotation.x
	var motion := InputEventMouseMotion.new()
	motion.screen_relative = Vector2(500.0, 500.0)
	root.push_input(motion, true)
	_check(is_equal_approx(_player.camera_pivot.rotation.y, yaw) and is_equal_approx(_player.spring_arm.rotation.x, pitch), "real dialogue locks camera look")
	_player.global_position.y = 7.0
	_player.velocity = Vector3(5.0, 0.0, 5.0)
	var initial_position := _player.global_position
	Input.action_press(&"move_forward")
	Input.action_press(&"sprint")
	await _physics(12)
	_check(_player.global_position.y < initial_position.y and _player.velocity.y < 0.0, "gravity continues with real dialogue open")
	_check(is_equal_approx(_player.global_position.x, initial_position.x) and is_equal_approx(_player.global_position.z, initial_position.z), "held movement and sprint cannot move locked player horizontally")
	await _physics(90)
	Input.action_release(&"move_forward")
	Input.action_release(&"sprint")
	_check(_player.is_on_floor() and absf(_player.global_position.y - 1.0) < 0.15, "ground collision remains active during dialogue")
	_player.global_position = Vector3(14.5, 1.0, 7.0)
	await _physics()
	# Force a test displacement through the active body to exercise its wall
	# collision independently of the intentionally disabled movement input.
	var contact := _player.move_and_collide(Vector3(4.0, 0.0, 0.0))
	_check(contact != null and _player.global_position.x < 15.5, "player collider still blocks solid wall during dialogue")
	_player.global_position.y = -12.0
	await _physics()
	_check(_player.global_position.distance_to(Vector3(0.0, 1.0, 0.0)) < 0.2, "respawn runs during real dialogue")
	await _close()
	await _approach()
	_target.conversation_id = &"unknown_integration_conversation"
	var opens_before := _opened.size()
	var closes_before := _closed.size()
	var selections_before := _selected.size()
	var mouse_before := Input.mouse_mode
	_key(KEY_E)
	_key(KEY_E, false)
	await _frames()
	_check(not _panel.is_conversation_open() and _opened.size() == opens_before and _closed.size() == closes_before and _selected.size() == selections_before, "failed conversation request emits no dialogue signals")
	_check(_player.is_movement_input_enabled() and _player.is_look_input_enabled() and Input.mouse_mode == mouse_before, "failed request preserves gameplay input and mouse")
	var z_before := _player.global_position.z
	Input.action_press(&"move_forward")
	await _physics(8)
	Input.action_release(&"move_forward")
	_check(_player.global_position.z < z_before - 0.2, "gameplay movement remains usable after failed request")
	_target.conversation_id = ID
	await _approach()
	var close_during_open := func(_id: StringName) -> void: _panel.close_conversation()
	_panel.conversation_opened.connect(close_during_open)
	_key(KEY_E)
	_key(KEY_E, false)
	await _frames()
	_check(not _panel.is_conversation_open() and _player.is_movement_input_enabled() and _player.is_look_input_enabled(), "real synchronous closure during open cannot leave controls locked")
	_panel.conversation_opened.disconnect(close_during_open)

func _run() -> void:
	root.size = Vector2i(1280, 720)
	_data = JSON.parse_string(FileAccess.get_file_as_string("res://data/dialogue/polling_officer_intro.json"))
	await _new_world()
	_check(_controller.get_node(_controller.player_path) == _player, "player NodePath resolves against actual tree")
	_check(_controller.get_node(_controller.dialogue_panel_path) == _panel, "dialogue NodePath resolves against actual tree")
	_check(_panel.get_parent() is CanvasLayer and _panel.get_parent().layer == 20, "real panel hosted in CanvasLayer20")
	_check(not _world.has_node("DialoguePanelSubstitute"), "combined scene contains no dialogue substitute")
	_check(_data.conversation_id == String(ID) and ROUTES.size() == 6, "six actual conversation routes scheduled")
	for route: Array in ROUTES:
		await _route(route)
	await _test_keyboard_and_focus()
	await _test_mouse()
	await _test_escape_and_restore()
	await _test_physics_and_failure()
	print("Combined integration checks: %d checks, %d failures; display=%s; captured-mouse scenarios=%d." % [_checks, _failures, DisplayServer.get_name(), _capture_checks])
	if _capture_checks == 0:
		print("SKIP: captured mouse restoration/recapture unavailable on this display; run windowed or manually playtest.")
	print("Synthetic input checks do not establish human input comfort, visual quality or Iris Xe performance.")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_world.queue_free()
	await _frames()
	quit(0 if _failures == 0 else 1)
