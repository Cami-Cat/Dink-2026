class_name SceneBase3D
extends SceneBase

func _ready() -> void:
	super()
	_teleport_player_to_spawn_point()
	return

func _connect_player() -> void:
	var player : CharacterController = get_tree().get_first_node_in_group(CharacterController.CHARACTER_GROUP_NAME)
	if !player : return
	player.player_died.connect(_teleport_player_to_spawn_point)
	return

func _teleport_player_to_spawn_point() -> void:
	var spawn_point : SpawnPoint = get_tree().get_first_node_in_group(SpawnPoint.SPAWN_POINT_GROUP_NAME)
	if !spawn_point : return
	var spawn_point_position : Vector3 = spawn_point.global_position
	var player : CharacterController = get_tree().get_first_node_in_group(CharacterController.CHARACTER_GROUP_NAME)
	player.global_position = spawn_point_position
	return
