class_name SaveSlot
extends Control

@export var index : int
@export var up_node : SaveSlot
@export var bottom_node : SaveSlot

@onready var save_info : Button = $SaveInfo
@onready var save_clear : Button = $delete

var is_new_save:bool

func _ready():
	save_info.pressed.connect(on_select)
	save_clear.pressed.connect(on_clear)
	display_save()

func set_focus():
	#current node
	save_info.focus_neighbor_right = save_clear.get_path()
	save_clear.focus_neighbor_left = save_info.get_path()
	
	if up_node:
		save_info.focus_neighbor_top = up_node.save_info.get_path()
		save_clear.focus_neighbor_top = up_node.save_clear.get_path()
	
	if bottom_node:
		save_info.focus_neighbor_bottom = bottom_node.save_info.get_path()
		save_clear.focus_neighbor_bottom = bottom_node.save_clear.get_path()

func on_select():
	var saveSys :SaveSystem = GameManager.save_system as SaveSystem
	GameManager.setting_data.last_save_played_index = index
	GameManager.save_system.save_setting(GameManager.setting_data)
	if is_new_save:
		saveSys.current_save_index = index
		GameManager.new_game()
	else:
		saveSys.load_game(index)
		SceneManager.change_scene_by_name(GameManager.player_data.last_scene_visit_path)
		SceneManager.need_respawn = true

func on_clear():
	var saveSys :SaveSystem = GameManager.save_system as SaveSystem
	saveSys.delete_save(index)
	display_save()

func display_save():
	var saveSys :SaveSystem = GameManager.save_system as SaveSystem
	var save_data:SaveData = saveSys.get_save_data(index)
	if save_data:
		is_new_save = false
		save_info.text = str("save ",index,"\n last_scene_visit ", save_data.player_data.last_scene_visit_path)
	else:
		is_new_save = true
		save_info.text = "Empty Save"

func play_select_audio():
	GameManager.audio_player.play_ui_select()
	
func play_pressed_audio():
	GameManager.audio_player.play_ui_pressed()
