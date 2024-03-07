class_name AudioPlayer
extends Node

@export var audio_player_2d : AudioStreamPlayer2D
@export var step : float = 0.01
@export var time_between_step : float = 0.2

func playAudio(audio_stream:AudioStream):
	audio_player_2d.stream = audio_stream
	audio_player_2d.play()

func crossfade_to(audio_stream: AudioStream):
	if audio_player_2d.stream == audio_stream: return
	if audio_player_2d.playing:
		var volume : float = 1
		while volume > 0:
			audio_player_2d.volume_db = linear_to_db(volume)
			await get_tree().create_timer(time_between_step).timeout
			volume -= step
		audio_player_2d.stop()
	
	audio_player_2d.volume_db = linear_to_db(1)
	audio_player_2d.stream = audio_stream
	audio_player_2d.play()
