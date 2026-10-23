class_name CharacterController extends RigidBody3D

var can_drag : bool = true
var dragging : bool = false
var click_position : Vector2
var click_power : float = 0.0 : 
	set(a):
		click_power = a
		click_power_updated.emit(click_power)
var max_click_power : float = 1.0
var min_click_power : float = 0.05
var shoot_power : float = 30.0
var distance_for_max_power : float = 450
var shoot_direction : Vector3

signal player_died()
signal input_released()
signal click_power_updated(to : float)
signal clicked_at(_position : float)
signal released_at(_position : float)

func _ready() -> void:
	freeze = true
	connect_signals()

func connect_signals() -> void:
	click_power_updated.connect(_print_click_power)
	input_released.connect(shoot_player)
	return

func _print_click_power(_click_power : float) -> void:
	print("Click power: %s" % [_click_power])
	return

func shoot_player() -> void:
	if click_power < min_click_power:
		can_drag = true
		return
	freeze = false
	apply_impulse(shoot_direction * (shoot_power * click_power), position)
	print("Player Launched")
	return

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Click"):
		if !can_drag : return
		if dragging : return
		dragging = true
		click_position = get_viewport().get_mouse_position()
		return
	if Input.is_action_just_released("Click"):
		dragging = false
		can_drag = false
		input_released.emit()
	if event is InputEventMouseMotion:
		if !dragging: return
		var current_pos : Vector2 = event.position
		var distance = click_position - current_pos
		click_power = clampf((distance.length() / distance_for_max_power), 0.0, 1.0)
		shoot_direction = Vector3(distance.normalized().x, 0.0, distance.normalized().y)
