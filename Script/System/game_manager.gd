@tool
extends Node
##############
# GameManager
# Autoload
##############
signal setup_settings
enum GameState {Gameplay,Stop}
var game_state : GameState = GameState.Gameplay

var player_data : PlayerData = preload("res://Script/Player/Data/player_data_resource.tres")
var setting_data : SettingData
var save_system : SaveSystem

func _ready():
	save_system = SaveSystem.new()
	setting_data = save_system.load_setting()
	setup_settings.emit()
	
func collect_save_data():
	pass

func new_game():
	# clear data and start at default scene
	player_data.current_health = player_data.max_health
	player_data.current_mana = player_data.max_mana
	SceneManager.change_scene_by_name("res://Scenes/Level/level_0_0.tscn")
	
func continue_game():
	save_system.load_game()
	if not player_data.last_scene_visit_path.is_empty():
		SceneManager.change_scene_by_name(player_data.last_scene_visit_path)
		SceneManager.need_respawn = true
	else:
		SceneManager.change_scene_by_name("res://Scenes/Level/level_0_0.tscn")
