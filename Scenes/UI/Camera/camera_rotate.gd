class_name CameraRotateUI
extends Control

@onready var main_camera:FollowCamera = get_tree().get_first_node_in_group("MainCamera")

func _ready() -> void:
	visible = false
	main_camera.camera_rotating.connect(_handle_camera_rotating)

func _handle_camera_rotating(state:bool):
	if state:
		if visible:
			return
		else:
			visibility_tween(true)
	else:
		if visible:
			visibility_tween(false)
	pass

func visibility_tween(state:bool):
	var new_tween:Tween = get_tree().create_tween()
	if state:
		visible = true
		new_tween.tween_property(self,"modulate",Color(1.0,1.0,1.0,0.8),0.1)
	else:
		new_tween.tween_property(self,"modulate",Color(1.0,1.0,1.0,0.0),0.1)
		new_tween.chain().tween_property(self,"visible",false,0.0)
	pass
