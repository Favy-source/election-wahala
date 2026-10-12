extends SceneTree
## Headless checks for DialoguePanel and the dialogue data files.
##
## Run from the project folder:
##   godot --headless --path . --script res://tests/dialogue/run_dialogue_tests.gd
## Exits with code 0 when every check passes, 1 otherwise.
## The invalid fixtures intentionally produce "Dialogue:" warnings.

const PanelScene := preload("res://scenes/ui/dialogue_panel.tscn")
const DialogueLibrary := preload("res://scripts/dialogue/dialogue_library.gd")
const DATA_DIRECTORY := "res://data/dialogue"
const FIXTURE_DIRECTORY := "res://tests/dialogue/fixtures"
const TEST_ID := &"polling_officer_intro"

var _checks: int = 0
var _failures := PackedStringArray()


## Records ui_cancel presses that reach gameplay-level unhandled input.
class EscapeSentinel extends Node:
	var escapes_seen: int = 0

	func _unhandled_input(event: InputEvent) -> void:
		if event.is_action_pressed(&"ui_cancel"):
			escapes_seen += 1


## Opens the conversation from _input on ui_accept, the earliest point an
## interaction system could react, to prove that press cannot also select.
class AcceptOpener extends Node:
	var panel: DialoguePanel

	func _input(event: InputEvent) -> void:
		if event.is_action_pressed(&"ui_accept") and not panel.is_conversation_open():
			panel.open_conversation(TEST_ID)


func _initialize() -> void:
	_run.call_deferred()


func _run() -> void:
	_test_data_files_are_valid()
	_test_invalid_fixtures_are_rejected()
	await _test_unknown_id_fails_quietly()
	await _test_open_once_and_reject_second_open()
	await _test_selection_waits_until_next_frame()
	await _test_repeated_presses_select_once()
	await _test_natural_end_closes_once()
	await _test_close_conversation_is_idempotent()
	await _test_listener_may_close_during_selection()
	await _test_escape_closes_and_is_consumed()
	await _test_opening_input_does_not_select()

	print("")
	if _failures.is_empty():
		print("Dialogue tests: all %d checks passed." % _checks)
	else:
		print("Dialogue tests: %d of %d checks FAILED:" % [_failures.size(), _checks])
		for failure in _failures:
			print("  - " + failure)
	quit(0 if _failures.is_empty() else 1)


# --- Data -----------------------------------------------------------------

func _test_data_files_are_valid() -> void:
	var files := DirAccess.get_files_at(DATA_DIRECTORY)
	_check(files.has("%s.json" % TEST_ID), "data contains %s.json" % TEST_ID)
	for file in files:
		if file.get_extension() != "json":
			continue
		var conversation := DialogueLibrary.load_conversation(DATA_DIRECTORY, StringName(file.get_basename()))
		_check(not conversation.is_empty(), "%s loads and validates" % file)

	var intro := DialogueLibrary.load_conversation(DATA_DIRECTORY, TEST_ID)
	if not intro.is_empty():
		_check(DialogueLibrary.get_dialogue_node(intro, intro.start_node).responses.size() >= 2,
			"%s offers at least two choices at the start" % TEST_ID)


func _test_invalid_fixtures_are_rejected() -> void:
	var files := DirAccess.get_files_at(FIXTURE_DIRECTORY)
	_check(files.size() >= 8, "invalid fixtures are present")
	for file in files:
		var conversation := DialogueLibrary.load_conversation(FIXTURE_DIRECTORY, StringName(file.get_basename()))
		_check(conversation.is_empty(), "fixture %s is rejected" % file)


# --- Panel behaviour ------------------------------------------------------

func _test_unknown_id_fails_quietly() -> void:
	var panel := _make_panel()
	var events := _record(panel)
	_check(not panel.open_conversation(&"no_such_conversation"), "unknown ID returns false")
	_check(not panel.open_conversation(&"../polling_officer_intro"), "malformed ID returns false")
	panel.dialogue_directory = FIXTURE_DIRECTORY
	_check(not panel.open_conversation(&"broken_missing_start"), "invalid file returns false")
	_check(events.is_empty(), "failed opens emit no signals")
	_check(not panel.is_conversation_open() and not panel.visible, "panel stays closed and hidden")
	await _free(panel)


func _test_open_once_and_reject_second_open() -> void:
	var panel := _make_panel()
	var events := _record(panel)
	_check(panel.open_conversation(TEST_ID), "valid ID returns true")
	_check(events == [["opened", TEST_ID]], "conversation_opened emitted once with the ID")
	_check(panel.is_conversation_open() and panel.visible, "panel is open and visible")
	_check(_label(panel, "SpeakerLabel") == "Polling Officer", "speaker name shown")
	_check(_buttons(panel).size() == 3, "greeting shows three responses")
	_check(not panel.open_conversation(TEST_ID), "second open of same ID rejected")
	_check(not panel.open_conversation(&"no_such_conversation"), "second open of other ID rejected")
	_check(events.size() == 1, "rejected opens emit nothing")
	await _free(panel)


func _test_selection_waits_until_next_frame() -> void:
	var panel := _make_panel()
	var events := _record(panel)
	panel.open_conversation(TEST_ID)
	_buttons(panel)[0].pressed.emit()
	_check(events.size() == 1, "press in the opening frame is ignored")
	await process_frame
	_check(_focused(panel) == _buttons(panel)[0], "first response has focus after a frame")
	_buttons(panel)[0].pressed.emit()
	_check(events.back() == ["selected", TEST_ID, &"greeting", &"here_to_vote"], "response_selected carries stable IDs")
	_check(_buttons(panel).size() == 2, "advanced to wait_instructions")
	await _free(panel)


func _test_repeated_presses_select_once() -> void:
	var panel := _make_panel()
	var events := _record(panel)
	panel.open_conversation(TEST_ID)
	await process_frame
	var first_button := _buttons(panel)[0]
	first_button.pressed.emit()
	first_button.pressed.emit()
	# The next node's buttons exist now but are not armed until next frame.
	_buttons(panel)[0].pressed.emit()
	_check(_count(events, "selected") == 1, "rapid and stale presses select only once")
	await process_frame
	_check(_count(events, "selected") == 1, "no deferred selection after repeated presses")
	await _free(panel)


func _test_natural_end_closes_once() -> void:
	var panel := _make_panel()
	var events := _record(panel)
	panel.open_conversation(TEST_ID)
	await process_frame
	_press_response(panel, "here_to_vote")
	await process_frame
	_press_response(panel, "will_wait")
	await process_frame
	_check(_label(panel, "BodyLabel") == "Thank you. Don't go far.", "farewell line shown before the end")
	_press_response(panel, "end_conversation")
	_check(events == [
		["opened", TEST_ID],
		["selected", TEST_ID, &"greeting", &"here_to_vote"],
		["selected", TEST_ID, &"wait_instructions", &"will_wait"],
		["selected", TEST_ID, &"farewell_wait", &"end_conversation"],
		["closed", TEST_ID],
	], "ending response emits selected then closed once")
	_check(not panel.is_conversation_open() and not panel.visible, "panel closed after natural end")
	_check(_buttons(panel).is_empty(), "responses cleared after close")
	await process_frame
	_check(events.size() == 5, "no late signals after close")
	await _free(panel)


func _test_close_conversation_is_idempotent() -> void:
	var panel := _make_panel()
	var events := _record(panel)
	panel.close_conversation()
	_check(events.is_empty(), "close while closed does nothing")
	panel.open_conversation(TEST_ID)
	panel.close_conversation()
	panel.close_conversation()
	_check(_count(events, "closed") == 1, "cancel emits conversation_closed once")
	_check(_count(events, "selected") == 0, "cancel selects nothing")
	_check(panel.open_conversation(TEST_ID), "can reopen after closing")
	await _free(panel)


func _test_listener_may_close_during_selection() -> void:
	var panel := _make_panel()
	var events := _record(panel)
	panel.response_selected.connect(func(_c, _n, _r): panel.close_conversation(), CONNECT_ONE_SHOT)
	panel.open_conversation(TEST_ID)
	await process_frame
	_press_response(panel, "here_to_vote")
	_check(events.slice(1) == [["selected", TEST_ID, &"greeting", &"here_to_vote"], ["closed", TEST_ID]],
		"listener closing inside response_selected is handled once")
	_check(not panel.is_conversation_open(), "panel stays closed")
	await _free(panel)


func _test_escape_closes_and_is_consumed() -> void:
	var panel := _make_panel()
	var events := _record(panel)
	var sentinel := EscapeSentinel.new()
	root.add_child(sentinel)
	panel.open_conversation(TEST_ID)
	await process_frame
	root.push_input(_key(KEY_ESCAPE, true))
	root.push_input(_key(KEY_ESCAPE, false))
	_check(_count(events, "closed") == 1 and not panel.is_conversation_open(), "Escape closes the conversation")
	_check(sentinel.escapes_seen == 0, "Escape is consumed while dialogue is open")
	root.push_input(_key(KEY_ESCAPE, true))
	_check(sentinel.escapes_seen == 1, "Escape reaches gameplay when dialogue is closed")
	_check(_count(events, "closed") == 1, "no extra close signal")
	sentinel.queue_free()
	await _free(panel)


func _test_opening_input_does_not_select() -> void:
	var panel := _make_panel()
	var events := _record(panel)
	var opener := AcceptOpener.new()
	opener.panel = panel
	root.add_child(opener)
	root.push_input(_key(KEY_ENTER, true))
	await process_frame
	root.push_input(_key(KEY_ENTER, false))
	await process_frame
	_check(panel.is_conversation_open(), "Enter opened the conversation")
	_check(_count(events, "selected") == 0, "the opening Enter press/release selects nothing")
	root.push_input(_key(KEY_ENTER, true))
	await process_frame
	root.push_input(_key(KEY_ENTER, false))
	await process_frame
	_check(_count(events, "selected") == 1, "a fresh Enter selects the focused response once")
	_check(events.back() == ["selected", TEST_ID, &"greeting", &"here_to_vote"], "keyboard selection uses the focused response")
	opener.queue_free()
	await _free(panel)


# --- Helpers ----------------------------------------------------------------

func _make_panel() -> DialoguePanel:
	var panel: DialoguePanel = PanelScene.instantiate()
	root.add_child(panel)
	return panel


func _free(panel: DialoguePanel) -> void:
	panel.queue_free()
	await process_frame


func _record(panel: DialoguePanel) -> Array:
	var events: Array = []
	panel.conversation_opened.connect(func(id): events.append(["opened", id]))
	panel.response_selected.connect(func(id, node, response): events.append(["selected", id, node, response]))
	panel.conversation_closed.connect(func(id): events.append(["closed", id]))
	return events


func _buttons(panel: DialoguePanel) -> Array[Node]:
	return panel.get_node("%ResponseList").get_children()


func _press_response(panel: DialoguePanel, response_id: String) -> void:
	panel.get_node("%%ResponseList/Response_%s" % response_id).pressed.emit()


func _label(panel: DialoguePanel, unique_name: String) -> String:
	return (panel.get_node("%" + unique_name) as Label).text


func _focused(panel: DialoguePanel) -> Control:
	return panel.get_viewport().gui_get_focus_owner()


func _count(events: Array, kind: String) -> int:
	return events.filter(func(event): return event[0] == kind).size()


func _key(keycode: Key, pressed: bool) -> InputEventKey:
	var event := InputEventKey.new()
	event.keycode = keycode
	event.physical_keycode = keycode
	event.pressed = pressed
	return event


func _check(condition: bool, description: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(description)
