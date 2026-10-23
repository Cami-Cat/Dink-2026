@tool
class_name PlayerTrigger extends Area3D

signal player_entered
signal player_exited

var collision_shape_3d : CollisionShape3D

@export_group("Activate On Stage")
@export var required_stage : int = 0
@export_group("Override Triggers")
@export var trigger_on_enter : Array[Node3D]
@export var trigger_on_exit : Array[Node3D]
@export_group("Override Size")
@export var area_size : Vector3 = Vector3(1.0, 1.0, 1.0):
	set(new_size):
		area_size = new_size
		if !collision_shape_3d:
			_create_collision_shape()
		if !collision_shape_3d.shape : return 
		_update_collision_shape()	

enum TRIGGER_STATE {
	ENTER,
	EXIT,
}

var enabled : bool = false

func _create_collision_shape() -> void:
	if self.get_child_count() > 0:
		for child in self.get_children():
			child.queue_free()
	print("Creating Collision Shape.")
	collision_shape_3d = CollisionShape3D.new()
	collision_shape_3d.shape = BoxShape3D.new()
	collision_shape_3d.debug_fill = true
	collision_shape_3d.debug_color = Color(0.875, 0.0, 0.236, 1.0)
	add_child(collision_shape_3d)
	_update_collision_shape()

func _update_collision_shape() -> void:
	print("Updating Size To: %s" % [area_size])
	collision_shape_3d.shape.size = area_size
	return

func _ready() -> void:
	_create_collision_shape()
	if Engine.is_editor_hint() : return
	_connect_signals()
	if required_stage == 0:
		enabled = true
	return

func _connect_signals() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	player_entered.connect(_force_trigger_enter)
	player_exited.connect(_force_trigger_exit)
	var scene : SceneBase3D = get_tree().get_first_node_in_group(SceneBase3D.SCENE_GROUP)
	scene.scene_completed.connect(_on_scene_completed)
	return

func _on_body_entered(body : Node3D) -> void:
	if !enabled : return
	if body is CharacterController:
		player_entered.emit()
		print("Player has entered trigger: %s" % [self.name])
	return

func _on_body_exited(body : Node3D) -> void:
	if !enabled : return
	if body is CharacterController:
		player_exited.emit()
		print("Player has exited trigger: %s" % [self.name])
	return
	
func _force_trigger_enter() -> void:
	for object in trigger_on_enter:
		if !object.has_method("on_trigger") : return
		object.on_trigger(TRIGGER_STATE.ENTER)
	return
	
func _force_trigger_exit() -> void:
	for object in trigger_on_exit:
		if !object.has_method("on_trigger") : return
		object.on_trigger(TRIGGER_STATE.EXIT)
	return
	
func _on_scene_completed(scene_num : int = 0) -> void:
	if scene_num < required_stage:
		return
	enabled = true
	return
