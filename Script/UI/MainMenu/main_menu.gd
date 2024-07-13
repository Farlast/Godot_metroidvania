extends CanvasUI

@export var first_select_button : Button
@export var first_select_save : SaveSlot

@export var main_option : Control
@export var save_select : Control
@export var animation_player : AnimationPlayer

enum Menu {main,save,ui}
var current_menu : Menu = Menu.main

func _ready()->void:
	await get_tree().create_timer(1).timeout
	animation_player.play("dissolve")
	await get_tree().create_timer(0.5).timeout
	call_deferred("set_button_focus")

func set_button_focus()->void:
	match current_menu:
		Menu.main:
			first_select_button.grab_focus()
			main_option.show()
			save_select.hide()
		Menu.save:
			first_select_save.get_focus()
			main_option.hide()
			save_select.show()

func play_ui_select()->void:
	var audio_player : AudioPlayer = GameManager.audio_player
	audio_player.play_ui_select()
func play_ui_pressed()->void:
	var audio_player : AudioPlayer = GameManager.audio_player
	audio_player.play_ui_pressed()

#region main options
func start_game()->void:
	current_menu = Menu.save
	set_button_focus()
	play_ui_pressed()
	GameManager.time_manager.unfreeze()
	GameManager.game_state = GameManager.GameState.GAMEPLAY
	
func continue_game()->void:
	if GameManager.setting_data.last_save_played_index > 0:
		GameManager.continue_game()

func settings_menu()->void:
	play_ui_pressed()
	SettingsMenu.open(self)

func quit_game()->void:
	play_ui_pressed()
	get_tree().quit()
#endregion

### save select
func back()->void:
	current_menu = Menu.main
	set_button_focus()
