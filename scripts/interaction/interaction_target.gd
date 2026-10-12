class_name InteractionTarget
extends Node3D

## Attach to a world object or its interaction marker, including a StaticBody3D.
## The dialogue provider owns content; this target only supplies stable IDs.
@export var target_id: StringName = &"polling_officer"
@export var conversation_id: StringName = &"polling_officer_intro"
@export var display_name: String = "Polling officer"
@export var enabled: bool = true
@export var interaction_offset: Vector3 = Vector3(0.0, 1.2, 0.0)

func _ready() -> void:
	add_to_group(&"interaction_targets")

func get_interaction_position() -> Vector3:
	return to_global(interaction_offset)
