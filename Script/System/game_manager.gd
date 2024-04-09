@tool
extends Node
############## GameManager ###############
## Autoload
## Service relay pattern
##########################################
signal setup_settings
signal game_state_changed(game_state)

enum GameState {GAMEPLAY,LOCK_CONTROLL,FREEZE}
var game_state : GameState :
	get:
		return game_state
	set(value):
		game_state = value
		game_state_changed.emit(game_state)

### player data relay
var player_data : PlayerData = preload("res://Script/Player/Data/player_data_resource.tres")
var audio_player_scene := preload("res://Scenes/UIComponent/audio_player.tscn")
### system relay
var setting_data : SettingData
var save_system : SaveSystem
var main_camera : CinematicCamera2D
var time_manager : TimeManager
var audio_player : AudioPlayer

func _ready():
	save_system = SaveSystem.new()
	time_manager = TimeManager.new(self)
	audio_player = audio_player_scene.instantiate() as AudioPlayer
	add_child(audio_player)
	setting_data = save_system.load_setting()
	setup_settings.emit()
	game_state = GameState.GAMEPLAY

#region Save system

func get_object_id(object: Object) -> String:
	return save_system.get_object_id(object)

func store_object(id: String , data : NodeSaveData):
	save_system.stored_objects[id] = data

func get_object(id: String) -> NodeSaveData:
	return save_system.stored_objects[id]

func is_object_stored(id: String) -> bool:
	return id in save_system.stored_objects

#endregion
func new_game():
	# clear data and start at default scene
	player_data.current_health = player_data.max_health
	player_data.current_mana = player_data.max_mana
	SceneManager.change_scene_by_name("res://Scenes/Level/Test/dev_room.tscn")
	
func continue_game():
	save_system.load_game(save_system.current_save_index)
	SceneManager.change_scene_by_name(player_data.last_scene_visit_path)
	SceneManager.need_respawn = true
	
