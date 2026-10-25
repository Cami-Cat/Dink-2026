class_name TriggeredAudio

extends AudioStreamPlayer

@onready var player : CharacterController = get_tree().get_first_node_in_group(CharacterController.CHARACTER_GROUP_NAME)
@onready var scene : SceneBase3D = get_tree().get_first_node_in_group(SceneBase3D.SCENE_GROUP)
@export var play_offset:float = 0.0
@export var wait_til_finish:bool = true
@export var disable_on_pin_hit:bool = true

var disabled:bool = true

func _ready() -> void:
	player.ball_hit_pin.connect(_handle_player_hit_pin)
	scene.player_reset.connect(_handle_player_respawn)
	
func on_trigger(trigger_event:PlayerTrigger.TRIGGER_STATE):
	if disabled: return
	if playing: return
	if trigger_event == PlayerTrigger.TRIGGER_STATE.ENTER:
		play(play_offset)
	pass

func _handle_player_hit_pin(..._args):
	if disable_on_pin_hit:
		disabled = true
	pass

func _handle_player_respawn():
	disabled = false
	pass
