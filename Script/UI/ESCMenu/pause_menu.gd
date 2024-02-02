extends Panel
class_name PauseMenu

@onready var defualt_button : Button = $VBoxContainer2/MarginContainer2/VBoxContainer/Continue
var fullscreen_btt : CheckButton
var is_focus : bool

func _ready():
	hide()
	is_focus = false

func _input(event):
	if event.is_action_released("ui_cancel") && !visible:
		TimeManager.freeze()
		display_state(true)
		defualt_button.grab_focus()
	elif event.is_action_released("ui_cancel") && visible: 
		TimeManager.unfreeze()
		display_state(false)
	
func _on_continue_pressed():
	TimeManager.unfreeze()
	display_state(false)

func _on_quit_pressed():
	TimeManager.unfreeze()
	get_tree().quit()

func _on_settings_pressed():
	SettingsMenu.show_Settings()
	display_state(false)
	
func on_to_menu_press():
	TimeManager.unfreeze()
	display_state(false)
	SceneManager.change_scene_by_name("res://Scenes/Menu/main_menu.tscn")

func display_state(state : bool):
	if state:
		is_focus = true
		GameManager.game_state = GameManager.GameState.Stop
		show()
	else:
		is_focus = false
		GameManager.game_state = GameManager.GameState.Gameplay
		hide()
	
