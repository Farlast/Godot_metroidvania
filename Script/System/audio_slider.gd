extends HSlider

@export_enum("Master","Music","Effect") var bus_index : int

func _ready():
	value_changed.connect(on_value_change)
	GameManager.setup_settings.connect(on_load_setting)
	
func on_value_change(_value : float):
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(_value))
	on_save_setting()

func on_save_setting():
	match bus_index:
		0:
			GameManager.setting_data.master_volume = value
		1:
			GameManager.setting_data.music_volume = value
		2:
			GameManager.setting_data.effect_volume = value
	
func on_load_setting():
	match bus_index:
		0:
			value = GameManager.setting_data.master_volume
		1:
			value = GameManager.setting_data.music_volume
		2:
			value = GameManager.setting_data.effect_volume
