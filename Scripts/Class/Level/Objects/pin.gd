class_name Pin extends RigidBody3D

signal pin_knocked_over

@onready var explode_timer: Timer = $ExplodeTimer

var knocked_over : bool = false

@export var knocked_over_threshold : float = 50
@export var wait_time_before_explode: float = 3.0

func _ready() -> void:
	return

func _process(_delta: float) -> void:
	if knocked_over : return
	if self.rotation_degrees.length() > knocked_over_threshold:
		knocked_over = true
		explode_timer.start()
		pin_knocked_over.emit()
	return


func _on_explode_timer_timeout() -> void:
	GVar.world_origin.spawn_pin_explosion_at_location(global_position,linear_velocity.normalized())
	freeze = true
	visible = false
	await get_tree().create_timer(0.5).timeout
	queue_free()
	pass # Replace with function body.
