class_name Indicator extends Node3D

@onready var indicator_head: MeshInstance3D = $IndicatorHead
@onready var indicator_body: MeshInstance3D = $IndicatorBody

const MAX_LENGTH : float = 40.0
const MIN_LENGTH : float = 0.0

var current_length : float = 0.0
var first_click_position : Vector2


func _ready() -> void:
	_connect_to_player()
	hide()
	return

func _connect_to_player() -> void:
	var player : CharacterController = get_tree().get_first_node_in_group(CharacterController.CHARACTER_GROUP_NAME)
	player.clicked_at.connect(_on_player_click.bind(player.global_position))
	player.click_power_updated.connect(_on_player_click_power_updated)
	player.mouse_moved.connect(_on_player_mouse_moved)
	player.input_released.connect(_on_player_released)

func _spawn_indicator(at_location : Vector3) -> void:
	# Some stupid shit just to make it spawn so I can test it.
	indicator_head.position = at_location
	return

func _on_player_click(click_position : Vector2, character_position : Vector3) -> void:
	first_click_position = click_position
	_spawn_indicator(character_position)
	show()
	return
	
func _on_player_click_power_updated(click_power : float) -> void:
	current_length = MAX_LENGTH * click_power
	return

func _on_player_mouse_moved(new_click_position : Vector2) -> void:
	var direction = (first_click_position - new_click_position).normalized()
	var direction_as_v3 : Vector3 = Vector3(direction.x, 0.0, direction.y)
	look_at(direction_as_v3 * 500.0)
	return

func _on_player_released(release_position : Vector2) -> void:
	current_length = 0
	first_click_position = Vector2.ZERO
	hide()
	return
