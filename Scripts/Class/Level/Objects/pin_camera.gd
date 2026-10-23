class_name pin_camera extends Camera3D

@export var pin_master : PinMaster

func on_trigger(trigger_state : PlayerTrigger.TRIGGER_STATE = PlayerTrigger.TRIGGER_STATE.ENTER) -> void:
	match trigger_state:
		PlayerTrigger.TRIGGER_STATE.ENTER:
			current = true
		PlayerTrigger.TRIGGER_STATE.EXIT:
			pass
	return

func _process(delta: float) -> void:
	if current:
		look_at(pin_master.get_center_of_nodes())
