extends ProgressBar
class_name StatusBar

@export var hp_event : HealthEvent
@export var indicator : ProgressBar
@export var lerp_time : float = 0.3
var lerp_timer : float

func _ready()->void:
	value = 10
	max_value = value
	lerp_timer = lerp_time
	hp_event.change.connect(update_hp)
	
func update_hp(_current:float,_max:float)->void:
	max_value = _max
	value = _current
	if not is_instance_valid(indicator):return
	indicator.max_value = _max
	if indicator.value > value:
		await get_tree().create_timer(0.3).timeout
		lerp_timer = 0
	else:
		indicator.value = value

func add_max_value()->void:
	#add bar length
	size = Vector2(size.x + 64,size.y)

func _process(delta:float)->void:
	lerp_indicator_value(delta)

func lerp_indicator_value(delta : float)->void:
	if lerp_timer < lerp_time:
		indicator.value = lerpf(indicator.value,value,lerp_timer/lerp_time)
		lerp_timer += delta
