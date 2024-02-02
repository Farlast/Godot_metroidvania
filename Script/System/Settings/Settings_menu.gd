extends CanvasLayer

##############
# Autoload
##############
signal saveSetting
@onready var fullscreen_btt : CheckButton = $Margin/VBoxContainer/TabContainer/Display/Fullscreen
@onready var master_volume : HSlider = $Margin/VBoxContainer/TabContainer/Audio/Master/HBox/MarginValue/Master
@onready var music_volume : HSlider = $Margin/VBoxContainer/TabContainer/Audio/Music/HBoxContainer/Margin/Music
@onready var effect_volume : HSlider = $Margin/VBoxContainer/TabContainer/Audio/Effect/HBoxContainer/Margin/Effect

func _ready():
	hide()
	GameManager.setup_settings.connect(set_default)

func set_default():
	fullscreen_btt.set_pressed_no_signal(GameManager.setting_data.fullscreen)
	_on_fullscreen_toggled(GameManager.setting_data.fullscreen)
	
func  show_Settings():
	fullscreen_btt.grab_focus()
	TimeManager.freeze()
	show()

func _on_fullscreen_toggled(button_pressed):
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	GameManager.setting_data.fullscreen = button_pressed

func _on_back_pressed():
	GameManager.save_system.save_setting(GameManager.setting_data)	
	TimeManager.unfreeze()
	hide()
