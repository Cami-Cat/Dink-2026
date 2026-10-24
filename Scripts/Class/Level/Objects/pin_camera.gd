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
	#if current:
	global_transform.basis = global_basis.slerp(desired_look_at.basis,delta * camera_speed)
	var furthest_pin_distance :float = pin_master.get_furthest_child_distance()
	furthest_pin_distance = clamp(remap(furthest_pin_distance,100,200,40,60),40,60)
	fov = move_toward(fov,furthest_pin_distance,delta * 10)
	print("Fov = %s" % fov)
