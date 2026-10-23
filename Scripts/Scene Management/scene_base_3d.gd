class_name SceneBase3D
extends SceneBase

const SCENE_GROUP : StringName = &"Scene"

var stage_num : int = 0

signal scene_completed(new_stage : int)

func _init() -> void:
	add_to_group(SCENE_GROUP)
	
func _ready() -> void:
	super()
	_teleport_player_to_spawn_point()
	_connect_player()
	return

func _connect_player() -> void:
	var player : CharacterController = get_tree().get_first_node_in_group(CharacterController.CHARACTER_GROUP_NAME)
	if !player : return
	player.player_died.connect(_respawn_player)
	return

func _teleport_player_to_spawn_point() -> void:
	var spawn_point : SpawnPoint = get_tree().get_first_node_in_group(SpawnPoint.SPAWN_POINT_GROUP_NAME)
	if !spawn_point : return
	var spawn_point_position : Vector3 = spawn_point.global_position
	var player : CharacterController = get_tree().get_first_node_in_group(CharacterController.CHARACTER_GROUP_NAME)
	if !player :return
	player.global_position = spawn_point_position
	return

func _respawn_player() -> void:
	var player : CharacterController = get_tree().get_first_node_in_group(CharacterController.CHARACTER_GROUP_NAME)
	var camera : FollowCamera = get_tree().get_first_node_in_group(FollowCamera.CAMERA_GROUP)
	player.freeze = true
	_teleport_player_to_spawn_point()
	player._reset()
	camera._reset()
	player.freeze = false

func _on_stage_complete() -> void:
	GVar.total_scene_completions += 1
	scene_completed.emit(GVar.total_scene_completions)
	stage_num = GVar.total_scene_completions
	return
