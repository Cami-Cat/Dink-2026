class_name PinExplosion
extends GPUParticles3D

var amount_variance = 0.2
var base_amount = 16
var input_direction:Vector3 = Vector3.UP
var mat:ParticleProcessMaterial


func _ready() -> void:
	amount = base_amount + round((randf_range(0,0.2) * base_amount))
	mat = process_material.duplicate()
	print(input_direction)
	mat.direction = input_direction
	restart()
