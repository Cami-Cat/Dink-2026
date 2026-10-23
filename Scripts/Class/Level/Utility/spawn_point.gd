class_name SpawnPoint extends Node3D

const SPAWN_POINT_GROUP_NAME : StringName = &"SpawnPoint"

func _ready() -> void:
	add_to_group(SPAWN_POINT_GROUP_NAME)
	return
