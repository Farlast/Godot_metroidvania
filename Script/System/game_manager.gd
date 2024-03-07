@tool
extends Node
##############
# GameManager
# Autoload
# Service relay pattern
##############
signal setup_settings
enum GameState {GAMEPLAY,LOCK_CONTROLL,FREEZE}
var game_state : GameState = GameState.GAMEPLAY

var player_data : PlayerData = preload("res://Script/Player/Data/player_data_resource.tres")
var setting_data : SettingData
### system relay
var save_system : SaveSystem

func _ready():
	save_system = SaveSystem.new()
	setting_data = save_system.load_setting()
	setup_settings.emit()

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
	
