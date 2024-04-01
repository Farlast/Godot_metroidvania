class_name PauseMenu
extends Control

@export var defualt_button : Button
var fullscreen_btt : CheckButton
var is_focus : bool

func _ready():
	hide()
	is_focus = false

func _input(event):
	if event.is_action_released("ui_cancel") && !visible:
		GameManager.time_manager.freeze()
		display_state(true)
		defualt_button.grab_focus()
	elif event.is_action_released("ui_cancel") && visible: 
		GameManager.time_manager.unfreeze()
		display_state(false)
	
func _on_continue_pressed():
	GameManager.time_manager.unfreeze()
	display_state(false)

func _on_quit_pressed():
	GameManager.time_manager.unfreeze()
	get_tree().quit()

func _on_settings_pressed():
	SettingsMenu.show_Settings()
	display_state(false)
	
func on_to_menu_press():
	GameManager.time_manager.unfreeze()
	display_state(false)
	SceneManager.change_scene_by_name("res://Scenes/Menu/main_menu.tscn")

func display_state(state : bool):
	if state:
		is_focus = true
		GameManager.game_state = GameManager.GameState.FREEZE
		show()
	else:
		is_focus = false
		GameManager.game_state = GameManager.GameState.GAMEPLAY
		hide()
	
