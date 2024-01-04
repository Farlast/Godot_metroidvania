extends HSlider

@export var bus_name: String
var bus_index : int

func _ready():
	value_changed.connect(on_value_change)
	bus_index = AudioServer.get_bus_index(bus_name)
	var volume = AudioServer.get_bus_volume_db(bus_index)
	on_value_change(db_to_linear(volume))
	
func on_value_change(_value : float):
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(_value))
