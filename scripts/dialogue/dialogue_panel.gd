class_name DialoguePanel
extends Control
## Reusable conversation panel (Shared Interaction–Dialogue Contract v1).
##
## Looks up a conversation by ID, displays it and reports the player's
## choices through signals. It never changes quests, money, inventory,
## affiliation or election state, and never touches the player: consumers
## react to the signals. Gameplay locking and mouse capture belong to the
## caller; this panel owns focus and navigation inside itself only.

signal conversation_opened(conversation_id: StringName)
signal response_selected(conversation_id: StringName, node_id: StringName, response_id: StringName)
signal conversation_closed(conversation_id: StringName)

const DialogueLibrary := preload("res://scripts/dialogue/dialogue_library.gd")
const RESPONSE_FONT_SIZE: int = 18
## Comfortable click target that keeps the box compact.
const RESPONSE_MIN_HEIGHT: float = 34.0
## The panel is centred near the bottom, never wider than this, and keeps at
## least SIDE_MARGIN from each screen edge on narrow windows.
const MAX_PANEL_WIDTH: float = 680.0
const SIDE_MARGIN: float = 16.0
## Share of the screen height the responses may fill before they scroll.
const MAX_RESPONSE_HEIGHT_RATIO: float = 0.4

## Folder holding one <conversation_id>.json file per conversation.
@export_dir var dialogue_directory: String = "res://data/dialogue"

var _conversation: Dictionary = {}
var _conversation_id: StringName = &""
var _node_id: StringName = &""
var _is_open: bool = false
# False until the frame after a node is shown, so the input that opened the
# conversation (or chose the previous response) cannot also choose this one.
var _accepting_selection: bool = false
# Changes on every node shown and every close, so stale button presses and
# deferred calls from an earlier node or session are ignored.
var _generation: int = 0

@onready var _speaker_label: Label = %SpeakerLabel
@onready var _body_label: Label = %BodyLabel
@onready var _response_list: VBoxContainer = %ResponseList
@onready var _response_scroll: ScrollContainer = %ResponseScroll
@onready var _frame: PanelContainer = %Frame


func _ready() -> void:
	hide()
	resized.connect(_update_layout)
	_response_list.minimum_size_changed.connect(_update_response_scroll_height)
	_update_layout()


func open_conversation(conversation_id: StringName) -> bool:
	if _is_open:
		push_warning("DialoguePanel: rejected '%s' while '%s' is open." % [conversation_id, _conversation_id])
		return false
	var conversation := DialogueLibrary.load_conversation(dialogue_directory, conversation_id)
	if conversation.is_empty():
		return false

	_conversation = conversation
	_conversation_id = conversation_id
	_is_open = true
	show()
	_show_node(StringName(conversation.start_node))
	conversation_opened.emit(conversation_id)
	return true


func close_conversation() -> void:
	if not _is_open:
		return
	var closed_id := _conversation_id
	_is_open = false
	_accepting_selection = false
	_generation += 1
	_clear_responses()
	_conversation = {}
	_conversation_id = &""
	_node_id = &""
	hide()
	# State is already reset, so a listener may open another conversation.
	conversation_closed.emit(closed_id)


func is_conversation_open() -> bool:
	return _is_open


func _input(event: InputEvent) -> void:
	# _input runs before gameplay _unhandled_input, so consuming Escape here
	# keeps it from also triggering the gameplay Escape action.
	if _is_open and event.is_action_pressed(&"ui_cancel"):
		get_viewport().set_input_as_handled()
		close_conversation()


func _show_node(node_id: StringName) -> void:
	var node := DialogueLibrary.get_dialogue_node(_conversation, node_id)
	_node_id = node_id
	_accepting_selection = false
	_generation += 1
	_speaker_label.text = DialogueLibrary.speaker_name(_conversation, node.speaker)
	_body_label.text = node.text

	_clear_responses()
	for response: Dictionary in node.responses:
		var button := Button.new()
		button.name = "Response_%s" % response.id
		button.text = response.text
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.custom_minimum_size.y = RESPONSE_MIN_HEIGHT
		button.add_theme_font_size_override(&"font_size", RESPONSE_FONT_SIZE)
		button.pressed.connect(_on_response_pressed.bind(_generation, StringName(response.id)))
		_response_list.add_child(button)
	_link_focus_loop()
	_enable_selection.call_deferred(_generation)


func _enable_selection(generation: int) -> void:
	if not _is_open or generation != _generation:
		return
	_accepting_selection = true
	if _response_list.get_child_count() > 0:
		# The list may still be settling its size, so follow_focus would scroll
		# against stale geometry. Start at the top, then follow later moves.
		_response_scroll.follow_focus = false
		(_response_list.get_child(0) as Button).grab_focus()
		_response_scroll.scroll_vertical = 0
		_response_scroll.set_deferred(&"follow_focus", true)


func _on_response_pressed(generation: int, response_id: StringName) -> void:
	if not _is_open or not _accepting_selection or generation != _generation:
		return
	_accepting_selection = false
	var node_id := _node_id
	var response := DialogueLibrary.find_response(_conversation, node_id, response_id)
	response_selected.emit(_conversation_id, node_id, response_id)
	# A listener may have closed or replaced the conversation.
	if not _is_open or generation != _generation:
		return
	if response.get("end") == true:
		close_conversation()
	else:
		_show_node(StringName(response.next))


func _clear_responses() -> void:
	for button: Button in _response_list.get_children():
		button.disabled = true
		_response_list.remove_child(button)
		button.queue_free()


func _update_layout() -> void:
	var width := minf(size.x - SIDE_MARGIN * 2.0, MAX_PANEL_WIDTH)
	_frame.offset_left = -width / 2.0
	_frame.offset_right = width / 2.0
	_update_response_scroll_height()


## Shows every response when they fit; past the height limit the list scrolls,
## and follow_focus keeps the focused response visible.
func _update_response_scroll_height() -> void:
	var needed := _response_list.get_combined_minimum_size().y
	_response_scroll.custom_minimum_size.y = minf(needed, size.y * MAX_RESPONSE_HEIGHT_RATIO)


## Up from the first response wraps to the last, and down from the last to the first.
func _link_focus_loop() -> void:
	var count := _response_list.get_child_count()
	if count < 2:
		return
	var first := _response_list.get_child(0) as Button
	var last := _response_list.get_child(count - 1) as Button
	first.focus_neighbor_top = first.get_path_to(last)
	last.focus_neighbor_bottom = last.get_path_to(first)
