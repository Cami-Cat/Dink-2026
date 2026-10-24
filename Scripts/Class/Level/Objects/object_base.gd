@abstract class_name ObjectBase extends Node3D

signal spawn_object

@export_group("Spawn Method")
@export var required_stage : int = 0
var enabled : bool = false

func _ready() -> void:
	var scene : SceneBase3D = get_tree().get_first_node_in_group(SceneBase3D.SCENE_GROUP)
	scene.scene_completed.connect(_on_scene_completed)
	enabled = false
	if required_stage <= 0:
		enabled = true
	return

func _on_scene_completed(new_stage_num : int) -> void:
	if new_stage_num < required_stage : return
	enabled = true
	return

@abstract func on_trigger(trigger_state : PlayerTrigger.TRIGGER_STATE)
