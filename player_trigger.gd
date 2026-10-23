class_name PlayerTrigger extends Area3D

signal player_entered
signal player_exited

@export_group("Override Triggers")
@export var trigger_on_enter : Array[Node3D]
@export var trigger_on_exit : Array[Node3D]

enum TRIGGER_STATE {
	ENTER,
	EXIT,
}

func _ready() -> void:
	return

func _connect_signals() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	player_entered.connect(_force_trigger_enter)
	player_exited.connect(_force_trigger_exit)
	return

func _on_body_entered(body : Node3D) -> void:
	if body is CharacterController:
		player_entered.emit()
	return

func _on_body_exited(body : Node3D) -> void:
	if body is CharacterController:
		player_exited.emit()
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
