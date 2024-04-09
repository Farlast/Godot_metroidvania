extends CanvasLayer
class_name MainMenu

@onready var first_select_button : Button = $Main/ButtonGroup/Start
@onready var first_select_save : Button = $SaveSelect/SaveVBoxContainer/SaveSlot/SaveInfo

@onready var main_option : Control = $Main
@onready var save_select : Control = $SaveSelect

@export_file("*.tscn") var first_area : String

enum Menu {main,save,ui}
var current_menu : Menu = Menu.main

func _ready():
	call_deferred("set_button_focus")

func set_button_focus():
	match current_menu:
		Menu.main:
			first_select_button.grab_focus()
			main_option.show()
			save_select.hide()
		Menu.save:
			first_select_save.grab_focus()
			main_option.hide()
			save_select.show()

func play_ui_select():
	var audio_player : AudioPlayer = GameManager.audio_player
	audio_player.play_ui_select()

func play_ui_pressed():
	var audio_player : AudioPlayer = GameManager.audio_player
	audio_player.play_ui_pressed()

func start_game():
	current_menu = Menu.save
	set_button_focus()
	
func continue_game():
	if GameManager.setting_data.last_save_played_index > 0:
		GameManager.continue_game()

func option_menu():
	SettingsMenu.show_Settings()

func quit_menu():
	get_tree().quit()

### save select
func back():
	current_menu = Menu.main
	set_button_focus()
