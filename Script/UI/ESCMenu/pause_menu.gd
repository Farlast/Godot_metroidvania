extends CanvasUI

func _ready()->void:
	hide()
	is_focus = true

func _input(event:InputEvent)->void:
	if not is_focus: return
	if not event.is_action_released("ui_cancel"):return
	if !visible:
		open(null)
	elif visible: 
		close()
		is_focus = true
	
func _on_continue_pressed()->void:
	close()
	is_focus = true

func _on_quit_pressed()->void:
	GameManager.time_manager.unfreeze()
	get_tree().quit()

func _on_settings_pressed()->void:
	close()
	SettingsMenu.open(self)
	
func on_to_menu_press()->void:
	close()
	SceneManager.change_scene_by_name("res://Scenes/Menu/main_menu.tscn")
