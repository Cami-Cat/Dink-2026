class_name CameraZoomUI
extends Control

@onready var progress_bar: ProgressBar = $HBoxContainer/ProgressBar

@onready var main_camera_holder:CameraHolder = get_tree().get_first_node_in_group(CameraHolder.CAMERA_HOLDER_GROUP)

@onready var fade_out_timer: Timer = $FadeOutTimer

func _ready() -> void:
	modulate = Color(1.0,1.0,1.0,0.0)
	main_camera_holder.zoom_changed.connect(_handle_camera_zoom_changed)

func _handle_camera_zoom_changed(new_percentage:float):
	progress_bar.value = progress_bar.max_value * new_percentage
	fade_in(true)
	fade_out_timer.start(2.0)

func fade_in(state:bool):
	var new_tween:Tween = get_tree().create_tween()
	var modulate_color:Color
	var time_taken:float
	if state:
		modulate_color = Color.WHITE
		time_taken = 0.2
	else:
		modulate_color = Color(1.0,1.0,1.0,0.0)
		time_taken = 1.0
		
	new_tween.tween_property(self,"modulate",modulate_color,time_taken)


func _on_fade_out_timer_timeout() -> void:
	fade_in(false)
	pass # Replace with function body.
