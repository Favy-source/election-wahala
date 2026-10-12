extends CanvasLayer
## Local contract test double. Claude's reusable panel replaces this at integration.
## This file deliberately contains no player, gameplay-state or mouse-mode access.

signal conversation_opened(conversation_id: StringName)
signal response_selected(
	conversation_id: StringName, node_id: StringName, response_id: StringName
)
signal conversation_closed(conversation_id: StringName)

const DATA_PATH := "res://tests/interaction/dialogue_substitute_data.json"

@onready var backdrop: ColorRect = $Backdrop
@onready var panel: PanelContainer = $Panel
@onready var body: Label = $Panel/Margin/Content/Body
@onready var response_button: Button = $Panel/Margin/Content/ResponseButton
@onready var cancel_button: Button = $Panel/Margin/Content/CancelButton

var _conversations: Dictionary = {}
var _conversation_id: StringName = &""
var _node_id: StringName = &""
var _response_id: StringName = &""
var _selection_ready: bool = false
var _selection_accepted: bool = false
var _opened_frame: int = -1


func _ready() -> void:
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(DATA_PATH))
	if parsed is Dictionary:
		_conversations = parsed.get("conversations", {})
	else:
		push_error("Dialogue test substitute could not load its local JSON data.")
	response_button.pressed.connect(_on_response_pressed)
	cancel_button.pressed.connect(close_conversation)
	_set_panel_visible(false)


func open_conversation(conversation_id: StringName) -> bool:
	if is_conversation_open() or not _conversations.has(String(conversation_id)):
		return false
	var conversation: Dictionary = _conversations[String(conversation_id)]
	var node_id := StringName(conversation.get("start_node", ""))
	var nodes: Dictionary = conversation.get("nodes", {})
	if not nodes.has(String(node_id)):
		return false
	var node: Dictionary = nodes[String(node_id)]
	var response: Dictionary = node.get("response", {})
	var response_id := StringName(response.get("id", ""))
	if node_id == &"" or response_id == &"":
		return false
	_conversation_id = conversation_id
	_node_id = node_id
	_response_id = response_id
	body.text = String(node.get("text", ""))
	response_button.text = String(response.get("text", ""))
	_selection_ready = false
	_selection_accepted = false
	_opened_frame = Engine.get_process_frames()
	response_button.disabled = true
	cancel_button.disabled = true
	_set_panel_visible(true)
	conversation_opened.emit(conversation_id)
	return true


func close_conversation() -> void:
	if not is_conversation_open():
		return
	var closed_id := _conversation_id
	_conversation_id = &""
	_node_id = &""
	_response_id = &""
	_selection_ready = false
	response_button.disabled = true
	cancel_button.disabled = true
	response_button.release_focus()
	cancel_button.release_focus()
	_set_panel_visible(false)
	conversation_closed.emit(closed_id)


func is_conversation_open() -> bool:
	return _conversation_id != &""


func _process(_delta: float) -> void:
	if not is_conversation_open() or _selection_ready or _selection_accepted:
		return
	# A held opening click/accept key cannot become the first response selection.
	if Engine.get_process_frames() <= _opened_frame:
		return
	if Input.is_action_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
	_selection_ready = true
	response_button.disabled = false
	cancel_button.disabled = false
	response_button.grab_focus()


func _input(event: InputEvent) -> void:
	if not is_conversation_open():
		return
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		close_conversation()
	elif event is InputEventKey and event.echo:
		# Ignore key repeats before built-in button navigation/accept handling.
		get_viewport().set_input_as_handled()
	elif not _selection_ready:
		if event.is_action("ui_accept") or event is InputEventMouseButton:
			get_viewport().set_input_as_handled()


func _on_response_pressed() -> void:
	if not is_conversation_open() or not _selection_ready or _selection_accepted:
		return
	_selection_accepted = true
	response_button.disabled = true
	cancel_button.disabled = true
	var selected_conversation := _conversation_id
	var selected_node := _node_id
	var selected_response := _response_id
	response_selected.emit(selected_conversation, selected_node, selected_response)
	# This technical fixture has one response and ends naturally after selection.
	close_conversation()


func _set_panel_visible(value: bool) -> void:
	backdrop.visible = value
	panel.visible = value
