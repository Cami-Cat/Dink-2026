class_name FollowCamera extends Camera3D

const CAMERA_GROUP : StringName = &"Camera"

@onready var shake_hit: CameraShake3DNode = $Shake_Hit


var shakePower : float = 1.0


func _ready() -> void:
	add_to_group(CAMERA_GROUP)
	return
	

func _reset() -> void:
	await get_tree().physics_frame
	current = true


func _on_character_controller_input_released(_position: Vector2) -> void:
	shake_hit._shake()

func _on_character_controller_click_power_updated(to: float):
	shakePower = to
