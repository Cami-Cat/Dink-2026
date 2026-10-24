class_name pin_camera extends Camera3D

@export var pin_master : PinMaster
@export var camera_speed:float = 2.0
var current_look_at:Vector3

func on_trigger(trigger_state : PlayerTrigger.TRIGGER_STATE = PlayerTrigger.TRIGGER_STATE.ENTER) -> void:
	match trigger_state:
		PlayerTrigger.TRIGGER_STATE.ENTER:
			current = true
		PlayerTrigger.TRIGGER_STATE.EXIT:
			pass
	return

func _process(delta: float) -> void:
	var desired_look_at:Transform3D = global_transform.looking_at(pin_master.get_center_of_nodes())
	if current:
		global_transform.basis = global_basis.slerp(desired_look_at.basis,delta * camera_speed)
