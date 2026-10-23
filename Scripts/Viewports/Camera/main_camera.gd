extends Camera3D

@export var follow_target : Node3D
@export var follow_distance : float = 15.0
@export var follow_acceleration : float = 50.0
@export var max_speed : float = 350.0

var current_speed : float = 20.0

func _ready() -> void:
	if !follow_target : return
	return
	
func _process(delta: float) -> void:
	if !follow_target: return
	
	var target_pos = follow_target.global_position + Vector3(0.0, follow_distance * 0.25, follow_distance)
	var distance_to_target = global_position.distance_to(target_pos)
	
	var target_speed = clamp(distance_to_target * follow_acceleration, -max_speed, max_speed)
	current_speed = move_toward(current_speed, target_speed, follow_acceleration * delta)
	
	global_position = global_position.move_toward(target_pos, current_speed * delta)
	look_at(follow_target.global_position)
	return
