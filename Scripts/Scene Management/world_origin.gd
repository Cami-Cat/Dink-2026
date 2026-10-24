class_name WorldOrigin
extends Node

const PIN_EXPLOSION = preload("uid://b3t3ffkfjc8hy")
const BOWLING_SONG = preload("uid://o1c5r5lh8hgt")

@onready var level: Node3D = $Level

func _ready() -> void:
	GVar.set("world_origin",self)
	_play_main_song()

func spawn_pin_explosion_at_location(location:Vector3,direction:Vector3):
	var new_particle:PinExplosion = PIN_EXPLOSION.instantiate()
	new_particle.input_direction = direction
	add_child(new_particle)
	new_particle.global_position = location

func create_noise_at_location(location:Vector3,wav_stream:AudioStreamWAV,pitch_scale:float):
	var new_audio:AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	new_audio.autoplay = false
	new_audio.stream = wav_stream
	new_audio.pitch_scale = pitch_scale
	new_audio.finished.connect(cleanup_3d_sound.bind(new_audio))
	new_audio.bus = &"SFX"
	add_child(new_audio)
	new_audio.play()
	new_audio.global_position = location
	
func cleanup_3d_sound(audio:AudioStreamPlayer3D):
	audio.queue_free()

func _play_main_song():
	var new_audio:AudioStreamPlayer = AudioStreamPlayer.new()
	new_audio.name = "MainSongPlayer"
	new_audio.autoplay = true
	new_audio.stream = BOWLING_SONG
	new_audio.bus = &"Music"
	level.add_child(new_audio)
	new_audio.play()
