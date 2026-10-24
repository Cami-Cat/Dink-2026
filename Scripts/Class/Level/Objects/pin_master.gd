@tool class_name PinMaster extends Node3D

signal pin_knocked_over(current_knocked_over_amount : int)

const PIN_GROUP : StringName = &"Pins"
const PIN_SCENE : PackedScene = preload("res://Scenes/Level/Objects/pin.tscn")
@export_group("Pin Distribution")
@export var total_pins : int = 10 :
	set(new_pin_count):
		total_pins = new_pin_count
		_reset()
@export var pin_spacing : float = 0.3 :
	set(new_spacing):
		pin_spacing = new_spacing
		_reset()

var resetting : bool = false
var pins_knocked_over : int = 0

func _init() -> void:
	add_to_group(PIN_GROUP)

func _reset() -> void:
	if resetting : return
	resetting = true
	pins_knocked_over = 0
	_clear_children()
	if !is_node_ready(): await ready
	call_deferred("_spawn_pyramid")
	resetting = false
	return

func _ready() -> void:
	if !PIN_SCENE:
		return
	_reset()
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
			if !Engine.is_editor_hint():
				pin_instance.pin_knocked_over.connect(_on_pin_knocked_over)
			pin_instance.freeze = true
			pins_spawned += 1
			pin_instance.name = str(pins_spawned)
		current_row += 1
		for pin in self.get_children():
			if pin is not Pin: continue
			pin.freeze = false
	return

func get_center_of_nodes() -> Vector3:
	if get_child_count() == 0:
		return Vector3.ZERO
	var weighted_position_sum: Vector3 = Vector3.ZERO
	var total_weight: float = 0.0
	for pin in get_children():
		if is_instance_valid(pin) and pin.is_inside_tree():
			var weight: float = global_position.distance_to(pin.global_position)
			if global_position.distance_to(pin.global_position) > 500:
				weight = 0.0
			weighted_position_sum += pin.global_position * weight
			total_weight += weight
	if total_weight <= 0.0:
		return global_position
	return weighted_position_sum / total_weight

func get_furthest_child_distance() -> float:
	var furthest_distance: float = 0.0
	for child: Node in get_children():
		if child is Node3D and is_instance_valid(child) and child.is_inside_tree():
			var distance: float = global_position.distance_to(
				(child as Node3D).global_position
			)
			
			furthest_distance = max(furthest_distance, distance)
	return furthest_distance


func _on_pin_knocked_over() -> void:
	pins_knocked_over += 1
	GVar.total_pins_knocked += 1
	pin_knocked_over.emit(pins_knocked_over)
	return
