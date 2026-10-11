extends RefCounted
## Loads and validates conversation data files.
##
## One conversation per file, named <conversation_id>.json. The schema is
## documented in docs/dialogue/DIALOGUE_PANEL.md.

const SCHEMA_VERSION: int = 1
const CONTENT_STATUSES: PackedStringArray = ["placeholder", "proposed", "approved"]

static var _id_pattern: RegEx


static func is_valid_id(id: String) -> bool:
	if _id_pattern == null:
		_id_pattern = RegEx.create_from_string("^[a-z][a-z0-9_]*$")
	return _id_pattern.search(id) != null


static func conversation_path(directory: String, conversation_id: StringName) -> String:
	return directory.path_join("%s.json" % conversation_id)


## Returns the validated conversation, or an empty Dictionary after logging
## a warning when the ID is unknown or the file is invalid.
static func load_conversation(directory: String, conversation_id: StringName) -> Dictionary:
	if not is_valid_id(conversation_id):
		push_warning("Dialogue: invalid conversation ID '%s'." % conversation_id)
		return {}

	var path := conversation_path(directory, conversation_id)
	if not FileAccess.file_exists(path):
		push_warning("Dialogue: unknown conversation '%s' (no file at %s)." % [conversation_id, path])
		return {}

	var json := JSON.new()
	if json.parse(FileAccess.get_file_as_string(path)) != OK:
		push_warning("Dialogue: %s line %d: %s" % [path, json.get_error_line(), json.get_error_message()])
		return {}
	if not json.data is Dictionary:
		push_warning("Dialogue: %s must contain a JSON object." % path)
		return {}

	var errors := validate(json.data, conversation_id)
	if not errors.is_empty():
		push_warning("Dialogue: %s is invalid:\n  %s" % [path, "\n  ".join(errors)])
		return {}
	return json.data


## JSON keys are Strings, so lookups convert StringName IDs explicitly.
static func get_dialogue_node(conversation: Dictionary, node_id: StringName) -> Dictionary:
	return conversation.nodes[String(node_id)]


static func speaker_name(conversation: Dictionary, speaker_id: String) -> String:
	return conversation.speakers[speaker_id].display_name


static func find_response(conversation: Dictionary, node_id: StringName, response_id: StringName) -> Dictionary:
	for response: Dictionary in get_dialogue_node(conversation, node_id).responses:
		if response.id == String(response_id):
			return response
	return {}


## Returns one message per problem; an empty array means the data is usable.
static func validate(data: Dictionary, expected_id: StringName) -> PackedStringArray:
	var errors := PackedStringArray()

	if typeof(data.get("schema_version")) != TYPE_FLOAT or int(data.schema_version) != SCHEMA_VERSION:
		errors.append("schema_version must be %d." % SCHEMA_VERSION)
	if data.get("conversation_id") != String(expected_id):
		errors.append("conversation_id must match the file name '%s'." % expected_id)
	var content_status: Variant = data.get("content_status")
	if not content_status is String or content_status not in CONTENT_STATUSES:
		errors.append("content_status must be one of %s." % ", ".join(CONTENT_STATUSES))

	var speakers: Variant = data.get("speakers")
	if not speakers is Dictionary or speakers.is_empty():
		errors.append("speakers must be a non-empty object.")
		speakers = {}
	for speaker_id: Variant in speakers:
		var speaker: Variant = speakers[speaker_id]
		if not is_valid_id(speaker_id):
			errors.append("speaker ID '%s' is not a snake_case identifier." % speaker_id)
		if not speaker is Dictionary or not _is_text(speaker.get("display_name")):
			errors.append("speaker '%s' needs a display_name." % speaker_id)

	var nodes: Variant = data.get("nodes")
	if not nodes is Dictionary or nodes.is_empty():
		errors.append("nodes must be a non-empty object.")
		return errors

	var start_node: Variant = data.get("start_node")
	if not start_node is String or not nodes.has(start_node):
		errors.append("start_node must name an existing node.")

	for node_id: Variant in nodes:
		errors.append_array(_validate_node(node_id, nodes[node_id], speakers, nodes))

	if errors.is_empty():
		var reachable := _reachable_nodes(data)
		var can_end := _nodes_that_can_end(nodes)
		for node_id: Variant in nodes:
			if node_id not in reachable:
				errors.append("node '%s' cannot be reached from start_node." % node_id)
			if node_id not in can_end:
				errors.append("node '%s' has no path to an ending response." % node_id)
	return errors


static func _validate_node(node_id: String, node: Variant, speakers: Dictionary, nodes: Dictionary) -> PackedStringArray:
	var errors := PackedStringArray()
	if not is_valid_id(node_id):
		errors.append("node ID '%s' is not a snake_case identifier." % node_id)
	if not node is Dictionary:
		errors.append("node '%s' must be an object." % node_id)
		return errors
	if not speakers.has(node.get("speaker")):
		errors.append("node '%s' has an unknown speaker." % node_id)
	if not _is_text(node.get("text")):
		errors.append("node '%s' needs text." % node_id)

	var responses: Variant = node.get("responses")
	if not responses is Array or responses.is_empty():
		errors.append("node '%s' needs at least one response." % node_id)
		return errors

	var seen_ids := {}
	for response: Variant in responses:
		if not response is Dictionary:
			errors.append("node '%s' has a response that is not an object." % node_id)
			continue
		var response_id: Variant = response.get("id")
		var label := "node '%s' response '%s'" % [node_id, response_id]
		if not response_id is String or not is_valid_id(response_id):
			errors.append("%s needs a snake_case id." % label)
		elif seen_ids.has(response_id):
			errors.append("%s is duplicated." % label)
		seen_ids[response_id] = true
		if not _is_text(response.get("text")):
			errors.append("%s needs text." % label)

		var ends: bool = response.get("end") == true
		var next: Variant = response.get("next")
		if ends == response.has("next"):
			errors.append("%s needs exactly one of \"end\": true or \"next\"." % label)
		elif not ends and (not next is String or not nodes.has(next)):
			errors.append("%s points to unknown node '%s'." % [label, next])
	return errors


static func _reachable_nodes(data: Dictionary) -> Dictionary:
	var reached := {}
	var pending: Array = [data.start_node]
	while not pending.is_empty():
		var node_id: String = pending.pop_back()
		if reached.has(node_id):
			continue
		reached[node_id] = true
		for response: Dictionary in data.nodes[node_id].responses:
			if response.has("next"):
				pending.append(response.next)
	return reached


## Nodes from which some sequence of choices reaches an "end": true response.
static func _nodes_that_can_end(nodes: Dictionary) -> Dictionary:
	var can_end := {}
	var changed := true
	while changed:
		changed = false
		for node_id: String in nodes:
			if can_end.has(node_id):
				continue
			for response: Dictionary in nodes[node_id].responses:
				if response.get("end") == true or can_end.has(response.get("next")):
					can_end[node_id] = true
					changed = true
					break
	return can_end


static func _is_text(value: Variant) -> bool:
	return value is String and not value.strip_edges().is_empty()
