class_name Pin extends RigidBody3D

signal pin_knocked_over

const SFX_PIN_HIT_1 = preload("uid://be8wsbhha5v8l")
const SFX_PIN_HIT_2 = preload("uid://ie7ngmeqaw7g")
const SFX_PIN_HIT_3 = preload("uid://dguc24cwqr0y4")

const hit_sounds:Array[AudioStreamWAV] = [SFX_PIN_HIT_1,SFX_PIN_HIT_2,SFX_PIN_HIT_3]

@onready var pin_hit_sound: AudioStreamPlayer3D = $PinHitSound
@onready var explode_timer: Timer = $ExplodeTimer

var knocked_over : bool = false

@export var knocked_over_threshold : float = 50
@export var wait_time_before_explode: float = 3.0

func _ready() -> void:
	explode_timer.stop()
	pin_hit_sound.stream = hit_sounds.pick_random()
	return

func _process(_delta: float) -> void:
	if knocked_over : return
	if !is_node_ready() : return
	if self.rotation_degrees.length() > knocked_over_threshold:
		knocked_over = true
		explode_timer.start()
		pin_knocked_over.emit()
	return

func _on_explode_timer_timeout() -> void:
	GVar.world_origin.spawn_pin_explosion_at_location(global_position,linear_velocity.normalized())
	freeze = true
	visible = false
	await get_tree().create_timer(0.5).timeout
	queue_free()
	pass # Replace with function body.


func _on_body_entered(body: Node) -> void:
	if body is RigidBody3D:
		var body_speed = body.linear_velocity.length()
		if body_speed > 1 or linear_velocity.length() > 1:
			pin_hit_sound.pitch_scale = remap(body_speed , 0,60,0.9,1.3)
			pin_hit_sound.play()
	pass # Replace with function body.
