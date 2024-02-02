extends CanvasLayer
class_name MainMenu


@onready var first_select_button : Button = $ButtonGroup/Start
@export_file("*.tscn") var first_area : String

func _ready():
	call_deferred("set_button_focus")

func set_button_focus():
	first_select_button.grab_focus()

func start_game():
	GameManager.new_game()
	
func continue_game():
	GameManager.continue_game()

func option_menu():
	SettingsMenu.show_Settings()

func quit_menu():
	get_tree().quit()
