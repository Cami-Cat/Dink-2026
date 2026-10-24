class_name FollowCamera extends Camera3D

const CAMERA_GROUP : StringName = &"Camera"

@export var follow_target : Node3D
@export var follow_distance : float = 15.0
@export var max_follow_distance : float = 15.0
@export var min_follow_distance : float = 5.0
@export var scroll_distance_change : float = 0.5
@export var follow_acceleration : float = 100.0
@export var max_speed : float = 350.0
@export var rotation_speed : float = 0.35

var current_speed : float = 20.0
var is_orbiting : bool = false

var orbit_angle_y: float = -PI
var orbit_angle_x: float = -0.2

var resetting : bool = false

func _ready() -> void:
	if !follow_target : return
	add_to_group(CAMERA_GROUP)
	return
	
func _process(delta: float) -> void:
	if resetting : return
	if !follow_target: return
	
	var camera_offset := Vector3.FORWARD
	camera_offset = camera_offset.rotated(Vector3.RIGHT, orbit_angle_x)
	camera_offset = camera_offset.rotated(Vector3.UP, orbit_angle_y)
	
	var target_pos = follow_target.global_position + (camera_offset * follow_distance) + Vector3(0.0, follow_distance * 0.25, 0.0)
	var distance_to_target = global_position.distance_to(target_pos)
	
	var target_speed = clamp(distance_to_target * follow_acceleration, -max_speed, max_speed)
	print(current_speed)
	current_speed = move_toward(current_speed, target_speed, follow_acceleration * delta)
	
	global_position = global_position.move_toward(target_pos, current_speed * delta)
	look_at(follow_target.global_position)
	return

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("RightClick"):
		is_orbiting = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if Input.is_action_just_released("RightClick"):
		is_orbiting = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseMotion:
		if !is_orbiting: return
		
		var rotation_amount : Vector2 = event.relative * deg_to_rad(rotation_speed)
		
		orbit_angle_y -= rotation_amount.x
		orbit_angle_x = clamp(orbit_angle_x + rotation_amount.y, deg_to_rad(-80), deg_to_rad(80))
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			follow_distance = clampf(follow_distance + scroll_distance_change, min_follow_distance, max_follow_distance)
			return
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			follow_distance = clampf(follow_distance - scroll_distance_change, min_follow_distance, max_follow_distance)
			return
	
func _reset() -> void:
	resetting = true
	await get_tree().physics_frame
	global_position = follow_target.global_position
	current_speed = 0.0
	resetting = false
	current = true
	return
