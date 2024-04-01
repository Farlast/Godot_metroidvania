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
var setting_data : SettingData
### system relay
var save_system : SaveSystem
var main_camera : CinematicCamera2D
var time_manager : TimeManager

func _ready():
	save_system = SaveSystem.new()
	time_manager = TimeManager.new(self)
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
	SceneManager.change_scene_by_name("res://Scenes/Level/level_0_0.tscn")
	
func continue_game():
	save_system.load_game(save_system.current_save_index)
	SceneManager.change_scene_by_name(player_data.last_scene_visit_path)
	SceneManager.need_respawn = true
	
