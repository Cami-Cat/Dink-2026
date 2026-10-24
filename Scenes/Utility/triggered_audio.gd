class_name TriggeredAudio

extends AudioStreamPlayer

func on_trigger(trigger_event:PlayerTrigger.TRIGGER_STATE):
	if trigger_event == PlayerTrigger.TRIGGER_STATE.ENTER:
		play(0.5)
	pass
