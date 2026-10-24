class_name SceneBase3D
extends SceneBase

const SCENE_GROUP : StringName = &"Scene"

var stage_num : int = 0
var required_pins : int = 0:
	set(a):
		required_pins = a
		required_pins_changed.emit(required_pins)
var required_pin_exponent : float = 0.8
var time_before_reset : float = 2.0
var ball_launches : int = 0
var stage_completed : bool = false

signal scene_completed(new_stage : int)
signal required_pins_changed(new_amount : int)

func _init() -> void:
	add_to_group(SCENE_GROUP)
	
func _ready() -> void:
	super()
	_teleport_player_to_spawn_point()
	_connect_player()
	_connect_pins()
	return

func _connect_pins() -> void:
	var pin_master : PinMaster = get_tree().get_first_node_in_group(PinMaster.PIN_GROUP)
	if !pin_master : return
	pin_master.pin_knocked_over.connect(_on_pin_knocked_over)
	required_pins = round(pin_master.total_pins * required_pin_exponent)
	return

func _connect_player() -> void:
	var player : CharacterController = get_tree().get_first_node_in_group(CharacterController.CHARACTER_GROUP_NAME)
	if !player : return
	player.player_died.connect(_respawn_player)
	player.input_released.connect(_on_ball_launch)
	player.player_timed_out.connect(_respawn_player)
	return

func _on_ball_launch(_released_at : Vector2) -> void:
	ball_launches += 1

func _teleport_player_to_spawn_point() -> void:
	var spawn_point : SpawnPoint = get_tree().get_first_node_in_group(SpawnPoint.SPAWN_POINT_GROUP_NAME)
	if !spawn_point : return
	var spawn_point_position : Vector3 = spawn_point.global_position
	var player : CharacterController = get_tree().get_first_node_in_group(CharacterController.CHARACTER_GROUP_NAME)
	if !player :return
	player.global_position = spawn_point_position
	player.freeze = true
	return

func _respawn_player() -> void:
	if stage_completed : return
	var player : CharacterController = get_tree().get_first_node_in_group(CharacterController.CHARACTER_GROUP_NAME)
	var camera : FollowCamera = get_tree().get_first_node_in_group(FollowCamera.CAMERA_GROUP)
	_teleport_player_to_spawn_point()
	player._reset()
	camera._reset()

func _on_pin_knocked_over(current_amount : int = 0) -> void:
	if current_amount >= required_pins:
		_on_stage_complete()
		return
	return

func _on_stage_complete() -> void:
	if stage_completed : return
	stage_completed = true
	GVar.total_scene_completions += 1
	stage_num = GVar.total_scene_completions
	_reset()
	return

func _reset() -> void:
	await get_tree().create_timer(time_before_reset).timeout
	var player : CharacterController = get_tree().get_first_node_in_group(CharacterController.CHARACTER_GROUP_NAME)
	var camera : FollowCamera = get_tree().get_first_node_in_group(FollowCamera.CAMERA_GROUP)
	var pin_master : PinMaster = get_tree().get_first_node_in_group(PinMaster.PIN_GROUP)
	pin_master._reset()
	if ball_launches > 0:
		player.freeze = true
		_teleport_player_to_spawn_point()
		player._reset()
		ball_launches = 0
		player.freeze = false
		camera._reset()
	scene_completed.emit(GVar.total_scene_completions)
	stage_completed = false
	return
