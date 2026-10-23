@tool class_name PinMaster extends Node3D

const PIN_SCENE : PackedScene = preload("res://Scenes/Level/Objects/pin.tscn")
@export_group("Pin Distribution")
@export var total_pins : int = 10 :
	set(new_pin_count):
		total_pins = new_pin_count
		_clear_children()
		_spawn_pyramid()
@export var pin_spacing : float = 0.3 :
	set(new_spacing):
		pin_spacing = new_spacing
		_clear_children()
		_spawn_pyramid()

func _ready() -> void:
	if !PIN_SCENE:
		return
	_clear_children()
	_spawn_pyramid()
	return

func _clear_children() -> void:
	for child in self.get_children():
		child.queue_free()

func _spawn_pyramid() -> void:
	var pins_spawned : int = 0
	var current_row : int = 1
	
	var row_depth_spacing = pin_spacing * (sqrt(3.0) / 2.0)
	
	var temp_pins = total_pins
	var expected_rows = 0
	var count = 1
	while temp_pins > 0:
		temp_pins -= count
		count += 1
		expected_rows += 1
	
	var total_pyramid_depth = (expected_rows - 1) * row_depth_spacing
	var z_center_offset = total_pyramid_depth / 2.0
	
	while pins_spawned < total_pins:
		var pins_in_this_row = current_row
		if pins_spawned + pins_in_this_row > total_pins:
			pins_in_this_row = total_pins - pins_spawned
			
		var row_width  = (pins_in_this_row - 1) * pin_spacing
		var x_start_offset = - row_width / 2.0
		
		for i in range(pins_in_this_row):
			var pin_instance = PIN_SCENE.instantiate() as Pin
			add_child(pin_instance)
			
			var local_x = x_start_offset + (i * pin_spacing)
			var local_z = z_center_offset - ((current_row - 1) * row_depth_spacing)
			
			pin_instance.position = Vector3(local_x, 0.0, local_z)
			pins_spawned += 1
			pin_instance.name = str(pins_spawned)
		current_row += 1
	return
