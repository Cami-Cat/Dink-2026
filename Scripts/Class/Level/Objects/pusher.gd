@tool
class_name Pusher extends ObjectBase

@onready var collision_shape_3d: CollisionShape3D = $MeshInstance3D/StaticBody3D/CollisionShape3D

@export_group("Setup")
@export var move_to : Vector3 :
	set(a):
		move_to = a
		if !Engine.is_editor_hint() : return
		draw_collision_at_move_to()
@export var move_over_time : float = 0.5

var preview_collision : CollisionShape3D
var start_position : Vector3

func create_preview_collision() -> void:
	if !is_node_ready():
		await ready
	destroy_preview_collision()
	preview_collision = CollisionShape3D.new()
	preview_collision.shape = collision_shape_3d.shape.duplicate()
	preview_collision.position = move_to
	add_child(preview_collision)
	preview_collision.owner = get_tree().edited_scene_root
	return

func destroy_preview_collision() -> void:
	if preview_collision:
		preview_collision.free()
	return

func draw_collision_at_move_to() -> void:
	if !preview_collision:
		create_preview_collision()
	preview_collision.position = move_to
	return

func _ready() -> void:
	if Engine.is_editor_hint(): 
		return
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
