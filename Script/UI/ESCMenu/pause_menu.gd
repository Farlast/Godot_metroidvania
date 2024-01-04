extends Panel
class_name PauseMenu

var fullscreen_btt : CheckButton

func _ready():
	hide()

func _input(event):
	if event.is_action_released("ui_cancel") && !visible:
		TimeManager.freeze()
		show()
	elif event.is_action_released("ui_cancel") && visible: 
		TimeManager.unfreeze()
		hide()
	
func _on_continue_pressed():
	TimeManager.unfreeze()
	hide()

func _on_quit_pressed():
	TimeManager.unfreeze()
	get_tree().quit()


func _on_settings_pressed():
	SettingsMenu.show_Settings()
	hide()
