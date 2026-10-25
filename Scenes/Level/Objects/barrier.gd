class_name Barrier
extends ObjectBase

@onready var start_rotation = global_rotation
@export var rotation_amount:Vector3
@export var move_over_time:float
func _ready() -> void:
	super()
	if !enabled: hide()
	rotation_amount = Vector3(deg_to_rad(rotation_amount.x),deg_to_rad(rotation_amount.y),deg_to_rad(rotation_amount.z))

func on_trigger(trigger_state : PlayerTrigger.TRIGGER_STATE) -> void:
	if !enabled : return
	match trigger_state:
		PlayerTrigger.TRIGGER_STATE.ENTER:
			var tween = create_tween()
			tween.tween_property(self, "rotation", global_rotation + rotation_amount, move_over_time).set_trans(tween.TRANS_SINE)
			await tween.finished
			tween.kill()
			tween = create_tween()
			tween.tween_property(self, "rotation", start_rotation, move_over_time).set_trans(tween.TRANS_SINE)
			await tween.finished
			tween.kill()
			return
		PlayerTrigger.TRIGGER_STATE.EXIT:
			return
	return


func _on_scene_completed(new_stage_num : int) -> void:
	super(new_stage_num)
	if enabled:
		show()
