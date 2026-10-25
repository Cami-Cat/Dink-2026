extends Node3D

@export var rotation_speed: float = 5.0

var rotation_axis: Vector3


func _ready() -> void:
	randomize()

	rotation_axis = Vector3(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()

	var random_scale: float = randf_range(0.5, 2.0)
	scale = Vector3.ONE * random_scale

	rotation = Vector3(
		deg_to_rad(randf_range(0.0, 360.0)),
		deg_to_rad(randf_range(0.0, 360.0)),
		deg_to_rad(randf_range(0.0, 360.0))
	)


func _process(delta: float) -> void:
	rotate(
		rotation_axis,
		deg_to_rad(rotation_speed) * delta
	)
