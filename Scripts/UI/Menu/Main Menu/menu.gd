class_name Menu extends Control

@onready var sfx_button_hover: AudioStreamPlayer = $SfxButtonHover
@onready var sfx_button_press: AudioStreamPlayer = $SfxButtonPress
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("PulseTitle")

func _get_play_button() -> Button:
	return $Buttons/VBoxContainer/Play

func _get_quit_button() -> Button:
	return $Buttons/VBoxContainer/Quit


func _on_play_mouse_entered() -> void:
	sfx_button_hover.play()
	pass # Replace with function body.


func _on_quit_mouse_entered() -> void:
	sfx_button_hover.play()
	pass # Replace with function body.


func _on_play_pressed() -> void:
	sfx_button_press.play()
	pass # Replace with function body.
