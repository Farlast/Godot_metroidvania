extends HSlider

@export_enum("Master","Music","Effect") var bus_index : int

func _ready()->void:
	value_changed.connect(on_value_change)
	on_load_setting()
	
func on_value_change(_value : float)->void:
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(_value))
	on_save_setting()

func on_save_setting()->void:
	match bus_index:
		0:
			GameManager.setting_data.master_volume = value
		1:
			GameManager.setting_data.music_volume = value
		2:
			GameManager.setting_data.effect_volume = value
	
func on_load_setting()->void:
	match bus_index:
		0:
			value = GameManager.setting_data.master_volume
		1:
			value = GameManager.setting_data.music_volume
		2:
			value = GameManager.setting_data.effect_volume
