class_name PinTracker
extends Control


@onready var pin_master:PinMaster = get_tree().get_first_node_in_group(PinMaster.PIN_GROUP)
@onready var scene:SceneBase3D = get_tree().get_first_node_in_group(SceneBase3D.SCENE_GROUP)

@onready var rich_text_label: RichTextLabel = $NinePatchRect/RichTextLabel

var knocked:int = 0
var required:int = 0

func _ready() -> void:
	pin_master.pin_knocked_over.connect(_handle_pins_knocked_changed)
	scene.required_pins_changed.connect(_handle_pins_required_changed)
	scene.scene_completed.connect(_handle_scene_completed)
	scene.play_pressed.connect(_handle_play_pressed)
	hide()
	required = scene.required_pins
	_update_label()

func _handle_scene_completed(_number_compelted_stages:int):
	knocked = 0
	_update_label()
	
func _handle_pins_required_changed(new_required:int):
	await scene.player_reset
	required = new_required
	
func _handle_pins_knocked_changed(new_total:int):
	if new_total < knocked:
		await scene.player_reset
	knocked = new_total
	_update_label()
	$PinTick.play()

func _handle_play_pressed():
	show()

func _update_label():
	rich_text_label.text = "%s of %s" % [knocked,required]
	pass
