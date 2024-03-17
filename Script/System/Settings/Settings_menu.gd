extends CanvasLayer

##############
# Autoload
##############
signal saveSetting
### Display
@onready var fullscreen_btt : CheckButton = $Margin/VBoxContainer/TabContainer/Display/Fullscreen
@onready var resolution_option : OptionButton = $Margin/VBoxContainer/TabContainer/Display/Resolution
### Audio
@onready var master_volume : HSlider = $Margin/VBoxContainer/TabContainer/Audio/Master/HBox/MarginValue/Master
@onready var music_volume : HSlider = $Margin/VBoxContainer/TabContainer/Audio/Music/HBoxContainer/Margin/Music
@onready var effect_volume : HSlider = $Margin/VBoxContainer/TabContainer/Audio/Effect/HBoxContainer/Margin/Effect

const RESOLUTION_DICTIONARY : Dictionary = {
	"1152 x 648" : Vector2(1152,648),
	"1280 x 720" : Vector2(1280,720),
	"1600 x 900" : Vector2(1600,900),
	"1920 x 1080" : Vector2(1920,1080)
}
func _ready():
	hide()
	GameManager.setup_settings.connect(set_default)
	setup_resolution_selecter()

func set_default():
	fullscreen_btt.set_pressed_no_signal(GameManager.setting_data.fullscreen)
	_on_fullscreen_toggled(GameManager.setting_data.fullscreen)
	resolution_option.select(GameManager.setting_data.screen_resolution_index)
	on_resolution_select(GameManager.setting_data.screen_resolution_index)

func  show_Settings():
	fullscreen_btt.grab_focus()
	TimeManager.freeze()
	show()

#region Display
func _on_fullscreen_toggled(button_pressed):
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	GameManager.setting_data.fullscreen = button_pressed

func setup_resolution_selecter():
	for item in RESOLUTION_DICTIONARY:
		resolution_option.add_item(item)
	resolution_option.item_selected.connect(on_resolution_select)

func on_resolution_select(index:int):
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
	GameManager.setting_data.screen_resolution_index = index

#endregion
func _on_back_pressed():
	GameManager.save_system.save_setting(GameManager.setting_data)	
	TimeManager.unfreeze()
	hide()