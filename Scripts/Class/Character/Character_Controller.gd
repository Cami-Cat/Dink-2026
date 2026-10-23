class_name CharacterController extends RigidBody3D

const CHARACTER_GROUP_NAME : StringName = &"Character"

signal player_died()
signal click_power_updated(to : float)
signal input_released(_position : Vector2)
signal clicked_at(_position : Vector2)

var can_drag : bool = true
var dragging : bool = false
var click_position : Vector2
@export_category("Power")
@export_group("Click Power")
@export var click_power : float = 0.0 : 
	set(a):
		click_power = a
		click_power_updated.emit(click_power)
@export var max_click_power : float = 1.0
@export var min_click_power : float = 0.05
@export_group("Distance")
@export var distance_for_max_power : float = 450
@export_group("Shoot Power")
@export var shoot_power : float = 300.0

var shoot_direction : Vector3

func _reset() -> void:
	can_drag = true
	return

func _init() -> void:
	add_to_group(CHARACTER_GROUP_NAME)

func _ready() -> void:
	freeze = true
	connect_signals()

func connect_signals() -> void:
	click_power_updated.connect(_print_click_power)
	input_released.connect(shoot_player)
	return

func _print_click_power(_click_power : float) -> void:
	return

func shoot_player(_position : Vector2) -> void:
	if click_power < min_click_power:
		can_drag = true
		return
	freeze = false
	apply_impulse(shoot_direction * (shoot_power * click_power), position)
	return

func _process(delta: float) -> void:
	if position.y < -20:
		player_died.emit()
		return

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Click"):
		if !can_drag : return
		if dragging : return
		dragging = true
		click_position = get_viewport().get_mouse_position()
		clicked_at.emit(click_position)
		return
	if Input.is_action_just_released("Click"):
		if !can_drag : return
		dragging = false
		can_drag = false
		input_released.emit(get_viewport().get_mouse_position())
	if event is InputEventMouseMotion:
		if !dragging: return
		var current_pos : Vector2 = event.position
		var distance = click_position - current_pos
		click_power = clampf((distance.length() / distance_for_max_power), 0.0, 1.0)
		shoot_direction = Vector3(distance.normalized().x, 0.0, distance.normalized().y)
