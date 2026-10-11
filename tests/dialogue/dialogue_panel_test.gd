extends Control
## Manual test scene for DialoguePanel. TEST SUBSTITUTE ONLY — not game code.
##
## Stands in for Codex's interaction system: it requests conversations by ID
## and simulates gameplay locking and mouse-capture restoration, so the panel
## can be exercised without the player, the polling scene or project changes.
## Keys are read directly because this branch has no "interact" action.

const TEST_ID := &"polling_officer_intro"

var _gameplay_locked: bool = false
var _simulated_mouse_mode: String = "CAPTURED"
var _mouse_mode_before_dialogue: String = ""

@onready var _panel: DialoguePanel = %DialoguePanel
@onready var _state_label: Label = %StateLabel
@onready var _log: RichTextLabel = %EventLog


func _ready() -> void:
	_panel.conversation_opened.connect(_on_conversation_opened)
	_panel.response_selected.connect(_on_response_selected)
	_panel.conversation_closed.connect(_on_conversation_closed)
	_refresh_state()
	_log_line("Ready. Press E or Enter to talk to the polling officer.")


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	match event.keycode:
		KEY_E, KEY_ENTER, KEY_KP_ENTER:
			_request(TEST_ID)
		KEY_U:
			_request(&"unknown_conversation")
		KEY_ESCAPE:
			# Only reached when the panel did not consume Escape.
			_log_line("[color=orange]Gameplay Escape received (would release the mouse).[/color]")


## The real interaction system would also skip requests while locked; this
## harness forwards them anyway so rejection of a second open can be seen.
func _request(conversation_id: StringName) -> void:
	var opened := _panel.open_conversation(conversation_id)
	_log_line("open_conversation(&\"%s\") -> %s" % [conversation_id, opened])


func _on_conversation_opened(conversation_id: StringName) -> void:
	# Lock only after a successful open, remembering the previous mouse state.
	_gameplay_locked = true
	_mouse_mode_before_dialogue = _simulated_mouse_mode
	_simulated_mouse_mode = "VISIBLE"
	_log_line("[color=lightgreen]conversation_opened[/color] %s" % conversation_id)
	_refresh_state()


func _on_response_selected(conversation_id: StringName, node_id: StringName, response_id: StringName) -> void:
	_log_line("[color=lightblue]response_selected[/color] %s / %s / %s" % [conversation_id, node_id, response_id])


func _on_conversation_closed(conversation_id: StringName) -> void:
	_gameplay_locked = false
	_simulated_mouse_mode = _mouse_mode_before_dialogue
	_log_line("[color=lightgreen]conversation_closed[/color] %s" % conversation_id)
	_refresh_state()


func _refresh_state() -> void:
	_state_label.text = "Simulated gameplay: %s    Simulated mouse: %s    Panel open: %s" % [
		"LOCKED" if _gameplay_locked else "FREE",
		_simulated_mouse_mode,
		_panel.is_conversation_open(),
	]


func _log_line(text: String) -> void:
	_log.append_text(text + "\n")
