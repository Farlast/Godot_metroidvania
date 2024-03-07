extends ProgressBar
class_name StatusBar

@export var hp_event : HealthEvent

func _ready():
	value = 100
	max_value = value
	hp_event.change.connect(update_hp)
	
func update_hp(_current,_max):
	value = _current
	max_value = _max

func add_bar_length():
	size = Vector2(size.x + 64,size.y)
