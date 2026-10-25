class_name CharacterController extends RigidBody3D

@onready var crowd_yay_sound: AudioStreamPlayer = $CrowdYaySound
@onready var rolling_sound: AudioStreamPlayer3D = $RollingSound
@onready var ball_hit_floor_sound: AudioStreamPlayer3D = $BallHitFloorSound
@onready var ball_grab_sound: AudioStreamPlayer = $BallGrabSound
@onready var main_camera:CameraHolder = get_tree().get_first_node_in_group(CameraHolder.CAMERA_HOLDER_GROUP)

const CHARACTER_GROUP_NAME : StringName = &"Character"

signal player_died()
signal click_power_updated(to : float)
signal input_released(_position : Vector2)
signal mouse_moved(_position : Vector2)
signal clicked_at(_position : Vector2)
signal ball_hit_pin(velocity : float , pin:Pin)
signal ball_hit_obstacle(velocity : float)
signal player_timed_out

var can_drag : bool = true
var has_hit_pin_sound : bool = false
var dragging : bool = false
var click_position : Vector2
var is_grounded: bool = false:
	set(a):
		if a != is_grounded:
			is_grounded = a
			_handle_grounded_state_changed()
@export_category("Power")
@export_group("Click Power")
@export var click_power : float = 0.0 : 
	set(a):
		click_power = a
		click_power_updated.emit(click_power)
@export var max_click_power : float = 1.5
@export var min_click_power : float = 0.5
@export_group("Distance")
@export var distance_for_max_power : float = 450
@export_group("Shoot Power")
@export var shoot_power : float = 300.0

@export_group("Roll Sound")
@export var max_pitch:float = 1.1
@export var min_pitch:float = 0.9
@export var min_pitch_speed:float = 0.0
@export var max_pitch_speed:float = 60.0
var shoot_direction : Vector3

@export_group("Timeout")
var timeout_timer : Timer
@export var timeout_length : float = 2.0 #s
var timing_out : bool = false

func _reset() -> void:
	has_hit_pin_sound = false
	can_drag = true
	timing_out = false
	return

func _init() -> void:
	add_to_group(CHARACTER_GROUP_NAME)

func _ready() -> void:
	timeout_timer = Timer.new()
	timeout_timer.timeout.connect(_on_timer_timeout)
	timeout_timer.one_shot = true
	add_child(timeout_timer)
	freeze = true
	connect_signals()

func connect_signals() -> void:
	click_power_updated.connect(_print_click_power)
	input_released.connect(shoot_player)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	return

func _print_click_power(_click_power : float) -> void:
	return

func shoot_player(_position : Vector2) -> void:
	if click_power < min_click_power:
		click_power = min_click_power
		return
	freeze = false
	apply_impulse(shoot_direction * (shoot_power * click_power), position)
	return

func _process(_delta: float) -> void:
	if position.y < -20:
		player_died.emit()
	if !freeze:
		if _is_grounded() and linear_velocity.length() > 0.6:
			rolling_sound.pitch_scale = remap(linear_velocity.length(),min_pitch_speed,max_pitch_speed,min_pitch,max_pitch)
			if !rolling_sound.playing:
				rolling_sound.play()
				$BallTrail.emitting = true
		else:
			if rolling_sound.playing:
				if !timing_out && !can_drag:
					timing_out = true
					# dep timeout_timer.start(timeout_length)
				rolling_sound.stop()
				$BallTrail.emitting = false
	return

func _is_grounded() -> bool:
	var space_state = get_world_3d().direct_space_state
	var start = global_position
	var end = start + Vector3.DOWN * 1
	var query = PhysicsRayQueryParameters3D.create(start,end)
	query.exclude = [self]
	is_grounded = !space_state.intersect_ray(query).is_empty()
	return is_grounded

func _handle_grounded_state_changed():
	if is_grounded:
		ball_hit_floor_sound.pitch_scale = randf_range(0.95,1.05)
		ball_hit_floor_sound.volume_db = remap(linear_velocity.length(),0,30,-3,3)
		ball_hit_floor_sound.play()

func _input(event: InputEvent) -> void:
	if GVar.is_menu_open : return
	if Input.is_action_just_pressed("Click"):
		if !can_drag : return
		if dragging : return
		ball_grab_sound.play()
		dragging = true
		click_position = get_viewport().get_mouse_position()
		clicked_at.emit(click_position)
		return
	if Input.is_action_just_released("Click"):
		if !can_drag : return
		dragging = false
		#can_drag = false
		input_released.emit(get_viewport().get_mouse_position())
	if event is InputEventMouseMotion:
		if !dragging: return
		var cam_forward:Vector3 = (-main_camera.global_basis.z).slide(Vector3.UP).normalized()
		var cam_right:Vector3 = (main_camera.global_basis.x).slide(Vector3.UP).normalized()
		var drag: Vector2 = click_position - event.position
		var world_drag : Vector3 = cam_right * drag.x - cam_forward * drag.y
		var direction:Vector3 = world_drag.normalized()
		
		mouse_moved.emit(event.global_position)
		click_power = clampf((drag.length() / distance_for_max_power), min_click_power, max_click_power)
		
		shoot_direction = Vector3(direction.normalized().x, 0.0, direction.normalized().z)

func _on_body_entered(body : Node3D) -> void:
	if is_zero_approx(linear_velocity.length()) : return
	if body is Pin:
		ball_hit_pin.emit(linear_velocity.length(),body)
		timing_out = true
		can_drag = false
		timeout_timer.start(timeout_length)
	else:
		ball_hit_obstacle.emit(linear_velocity.length())
	print("Ball Velocity: %s" % linear_velocity.length())
	return

func _on_timer_timeout() -> void:
	player_timed_out.emit()
	return

func _on_body_exited(body : Node3D) -> void:
	pass


func _on_ball_hit_pin(speed: float , pin:Pin) -> void:
	$BallHit.restart()
	$BallHit.emitting = true
	if has_hit_pin_sound == false:
		GFnc.apply_hitlag(0.15)
		var dir:Vector3 = (global_position - pin.global_position).normalized()
		dir.y = 0
		var _velocity = dir * min(speed,20) * 0.1
		print(speed)
		pin.apply_impulse(_velocity,global_position)
		crowd_yay_sound.play()
		has_hit_pin_sound = true
