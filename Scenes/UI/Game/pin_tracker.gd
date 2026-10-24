class_name PinTracker
extends Control

@onready var pin_master:PinMaster = get_tree().get_first_node_in_group(PinMaster.PIN_GROUP)

@onready var rich_text_label: RichTextLabel = $NinePatchRect/RichTextLabel

var knocked:int = 0
var required:int = 0

func _ready() -> void:
	pin_master.pin_knocked_over.connect(_handle_pins_knocked_changed)
	_update_label()

func _handle_pins_required_changed(new_required:int):
	required = new_required
	pass
	
func _handle_pins_knocked_changed(new_total:int):
	knocked = new_total
	pass

func _update_label():
	rich_text_label.text = "%s of %s" % [knocked,required]
	pass
