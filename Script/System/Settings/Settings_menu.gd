extends CanvasUI

##############
# Autoload
##############

signal saveSetting

@export_group("Display")
@export var fullscreen_btt : CheckButton
@export var resolution_option : OptionButton
@export var fps_option : OptionButton
@export_group("Audio")
@export var master_volume : HSlider
@export var music_volume : HSlider
@export var effect_volume : HSlider

const RESOLUTION_DICTIONARY : Dictionary = {
	"1152 x 648" : Vector2(1152,648),
	"1280 x 720" : Vector2(1280,720),
	"1600 x 900" : Vector2(1600,900),
	"1920 x 1080" : Vector2(1920,1080)
}
const FPS_OPTIONS : Dictionary = {
	"No limit":-1,
	"30": 30,
	"60": 60,
	"75": 75,
	"120": 120,
	"165": 140,
	"180": 180,
	"200": 200
}

func _ready()->void:
	hide()
	setup_resolution_selecter()
	setup_fps_select()
	set_default()

func set_default()->void:
	fullscreen_btt.set_pressed_no_signal(GameManager.setting_data.fullscreen)
	_on_fullscreen_toggled(GameManager.setting_data.fullscreen)
	resolution_option.select(GameManager.setting_data.screen_resolution_index)
	on_resolution_select(GameManager.setting_data.screen_resolution_index)

#region Display
func _on_fullscreen_toggled(button_pressed:bool)->void:
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		on_resolution_select(GameManager.setting_data.screen_resolution_index)
		
	GameManager.setting_data.fullscreen = button_pressed

func setup_resolution_selecter()->void:
	for item:String in RESOLUTION_DICTIONARY:
		resolution_option.add_item(item)
	resolution_option.item_selected.connect(on_resolution_select)

func on_resolution_select(index:int)->void:
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
	GameManager.setting_data.screen_resolution_index = index

func setup_fps_select()->void:
	for item:String in FPS_OPTIONS:
		fps_option.add_item(item)
	fps_option.item_selected.connect(on_fps_select)

func on_fps_select(index:int)->void:
	Engine.max_fps = FPS_OPTIONS.values()[index]

#endregion
func _on_back_pressed()->void:
	GameManager.save_system.save_setting(GameManager.setting_data)
	back_to_previous()
