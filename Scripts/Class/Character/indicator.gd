class_name Indicator extends Node3D

@onready var indicator_head: MeshInstance3D = $IndicatorHead
@onready var indicator_body: MeshInstance3D = $IndicatorHead/IndicatorBody
@onready var player : CharacterController = get_tree().get_first_node_in_group(CharacterController.CHARACTER_GROUP_NAME)
@onready var main_camera:CameraHolder = get_tree().get_first_node_in_group(CameraHolder.CAMERA_HOLDER_GROUP)
var M_INDICATOR:StandardMaterial3D = preload("res://Assets/Meshes/Indicator/M_Indicator.tres")
var last_click_power:float = 1.0

const MAX_LENGTH : float = 200.0
const MIN_LENGTH : float = 0.0

var current_length : float = 0.0
var first_click_position : Vector2

var tween:Tween

func _ready() -> void:
	_connect_to_player()
	pulse_tween()
	hide()
	return

func _physics_process(_delta: float) -> void:
	global_position = player.global_position #- Vector3(0,0,-1)

func _connect_to_player() -> void:
	player.clicked_at.connect(_on_player_click)
	player.click_power_updated.connect(_on_player_click_power_updated)
	player.mouse_moved.connect(_on_player_mouse_moved) 
	player.input_released.connect(_on_player_released)

func _spawn_indicator(at_location : Vector3) -> void:
	# Some stupid shit just to make it spawn so I can test it.
	indicator_head.position = at_location# - Vector3(0,0,-1)
	return

func _on_player_click(click_position : Vector2, _character_position : Vector3 = player.global_position) -> void:
	first_click_position = click_position
	rotation.y = main_camera.rotation.y
	#_spawn_indicator(_character_position)
	show()
	return

func pulse_tween():
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_method(_pulse_color,0.0,1.0,last_click_power)
	tween.chain().tween_method(_pulse_color,1.0,0.0,last_click_power)
	tween.chain().tween_callback(pulse_tween)

func _pulse_color(value:float):
	var color:Color = lerp(Color("c0001e"),Color("bf4e5fff"),value)
	M_INDICATOR.albedo_color = color

func _on_player_click_power_updated(click_power : float) -> void:
	last_click_power = remap(click_power,0.5,1.2,0.6,0.3)
	current_length = MAX_LENGTH * click_power
	var f:float = 1.0 + click_power
	scale = Vector3(f,f,f)
	return

func _on_player_mouse_moved(new_click_position : Vector2) -> void:
	var drag_direction:Vector2 = (first_click_position - new_click_position).normalized()
	drag_direction.y = -drag_direction.y
	var cam_forward:Vector3 = (-main_camera.global_basis.z).slide(Vector3.UP).normalized()
	var cam_right:Vector3 = (main_camera.global_basis.x).slide(Vector3.UP).normalized()
	var look_direction:Vector3 = (cam_right * drag_direction.x + cam_forward * drag_direction.y).normalized()

	look_at(global_position + look_direction * 100)
	return

func _on_player_released(release_position : Vector2) -> void:
	current_length = 0
	first_click_position = Vector2.ZERO
	hide()
	return
