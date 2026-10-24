class_name WorldOrigin
extends Node

const PIN_EXPLOSION = preload("uid://b3t3ffkfjc8hy")

func _ready() -> void:
	GVar.set("world_origin",self)

func spawn_pin_explosion_at_location(location:Vector3,direction:Vector3):
	var new_particle:PinExplosion = PIN_EXPLOSION.instantiate()
	new_particle.input_direction = direction
	add_child(new_particle)
	new_particle.global_position = location
