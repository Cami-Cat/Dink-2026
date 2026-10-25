extends Control

@onready var scene:SceneBase3D = get_tree().get_first_node_in_group(SceneBase3D.SCENE_GROUP)
@onready var player:CharacterController = get_tree().get_first_node_in_group(CharacterController.CHARACTER_GROUP_NAME)
@onready var start_position:Vector2 = position
var active:bool = true
var tween:Tween

func _ready() -> void:
	hide()
	scene.play_pressed.connect(_handle_play_pressed)
	player.clicked_at.connect(_handle_player_clicked)
	
func _handle_play_pressed():
	await get_tree().create_timer(5.0).timeout
	if active:
		_play_anim()
	pass
	
func _handle_player_clicked(..._args):
	active = false
	if tween:
		if tween.is_running():
			tween.kill()
			hide()
	pass

func _play_anim():
	tween = get_tree().create_tween()
	tween.tween_callback(show)
	tween.tween_property(self,"scale",Vector2(1.0,1.0),0.5)
	tween.tween_property(self,"position",start_position + Vector2(0,200),2.0)
	tween.tween_property(self,"scale",Vector2(0.0,0.0),0.5)
	tween.tween_callback(hide)
	await tween.finished
	position = start_position
	if active:
		_play_anim()
	
