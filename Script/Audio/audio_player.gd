class_name AudioPlayer
extends Node

@export_category("Pooling")
@export_range(0,10,1) var max_pool : int = 5
@export var audio_pool_2d : Array[AudioStreamPlayer2D]
@export_category("Fade BGM and Ambient")
@export var ambient_player : AudioStreamPlayer
@export var bgm_player : AudioStreamPlayer
@export var step : float = 0.01
@export var time_between_step : float = 0.2
@export_category("UI")
@export var audio_player : AudioStreamPlayer
@export var select : AudioStream
@export var press : AudioStream

func _ready()->void:
	var new_player : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	audio_pool_2d.append(new_player)
	add_child(new_player)

#region UI
### ============ UI ===============
func play_ui_select()->void:
	audio_player.stream = select
	audio_player.play()

func play_ui_pressed()->void:
	audio_player.stream = press
	audio_player.play()
#endregion

#region Custom pooling
### ============ Custom pooling ===============
func play(audio_stream:AudioStream, position : Vector2, volume_db : float = 0)->void:
	var avalible_player: AudioStreamPlayer2D = null
	for player in audio_pool_2d:
		if not player.playing:
			avalible_player = player
	# no avalible in array make new
	if avalible_player == null:
		var new_player : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		audio_pool_2d.append(new_player)
		new_player.bus = "Effect"
		new_player.stream = audio_stream
		new_player.position = position
		new_player.volume_db = volume_db
		add_child(new_player)
		new_player.play()
	else:
		avalible_player.stream = audio_stream
		avalible_player.position = position
		avalible_player.volume_db = volume_db
		avalible_player.play()
	clear_oversize_pool()

func clear_oversize_pool()->void:
	if audio_pool_2d.size() > max_pool:
		for i in max_pool - audio_pool_2d.size():
			for player in audio_pool_2d:
				if not player.playing:
					player.queue_free()
#endregion

#region New Code Region
### ============ BGM and Ambient ===============
func change_bgm(audio_stream: AudioStream)->void:
	crossfade_to(bgm_player,audio_stream)

func change_ambient(audio_stream: AudioStream)->void:
	crossfade_to(ambient_player,audio_stream)

func fade_bgm()->void:
	fade_to_none(bgm_player)

func fade_ambient()->void:
	fade_to_none(ambient_player)

func crossfade_to(player: AudioStreamPlayer, audio_stream: AudioStream)->void:
	if player.stream == audio_stream: return
	if player.playing:
		var volume : float = 1
		while volume > 0:
			player.volume_db = linear_to_db(volume)
			await get_tree().create_timer(time_between_step).timeout
			volume -= step
		player.stop()
	
	player.volume_db = linear_to_db(1)
	player.stream = audio_stream
	player.play()

func fade_to_none(player: AudioStreamPlayer)->void:
	if player.playing:
		var volume : float = 1
		while volume > 0:
			player.volume_db = linear_to_db(volume)
			await get_tree().create_timer(time_between_step).timeout
			volume -= step
		player.stop()
#endregion
