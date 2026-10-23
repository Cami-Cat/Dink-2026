class_name Pusher extends ObjectBase

@onready var collision_shape_3d: CollisionShape3D = $MeshInstance3D/StaticBody3D/CollisionShape3D

@export_group("Setup")
@export var move_to : Vector3 :
	set(a):
		move_to = a
@export var pusher_power : float = 100.0
@export var move_over_time : float = 0.5

var preview_collision : CollisionShape3D
var start_position : Vector3

func _ready() -> void:
	super()
	start_position = global_position
	return
	
func on_trigger(trigger_state : PlayerTrigger.TRIGGER_STATE) -> void:
	match trigger_state:
		PlayerTrigger.TRIGGER_STATE.ENTER:
			var tween = create_tween()
			tween.tween_property(self, "position", global_position + move_to, move_over_time).set_trans(tween.TRANS_SINE)
			await tween.finished
			tween.kill()
			return
		PlayerTrigger.TRIGGER_STATE.EXIT:
			return
	return


func _on_launch_body_entered(body: Node3D) -> void:
	if body is CharacterController:
		body.apply_impulse(move_to.normalized() * pusher_power, position)
