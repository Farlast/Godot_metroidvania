extends Control

@export var hp_event : HealthEvent
@onready var empty :TextureRect = $health_empty
@onready var fill :TextureRect = $health_fill

var original_size : float = 96

func _ready():
	hp_event.change_HP.connect(update_hp)
	
func update_hp(_current,_max):
	if _current <= 0:
		fill.hide()
	else:
		fill.show()
		fill.size.x = original_size * _current
	empty.size.x = original_size * _max
