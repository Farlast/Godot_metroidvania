class_name StatusValue
extends Resource

signal ReachZero

var current_value : float
@export var max_value : float

func setup()->void:
	current_value = max_value

func substrect(substrect_value:float)->void:
	current_value -= substrect_value
	if current_value <= 0:
		current_value = 0
		ReachZero.emit()

func add(add_value:float)->void:
	current_value += add_value
	if current_value > max_value:
		current_value = max_value
