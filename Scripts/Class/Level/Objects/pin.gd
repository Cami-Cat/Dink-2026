class_name Pin extends RigidBody3D

signal pin_knocked_over()

var knocked_over : bool = false

@export var knocked_over_threshold : float = 50

func _ready() -> void:
	return

func _process(delta: float) -> void:
	if knocked_over : return
	if self.rotation_degrees.length() > knocked_over_threshold:
		knocked_over = true
		pin_knocked_over.emit()
	return
