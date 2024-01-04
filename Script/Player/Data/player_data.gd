extends Resource
class_name PlayerData

@export_group("Health")
#region Health
@export var max_health : float = 3:
	get:
		return max_health + max_health_extend

var max_health_extend : float = 0:
	get:
		return max_health_extend
	set(value):
		max_health_extend = value

var current_health : float:
	get:
		return current_health
	set(value):
		current_health = value
#endregion

#region Mana
@export var max_mana : float = 5:
	get:
		return max_mana + max_mana_extend

var max_mana_extend : float:
	get:
		return max_mana_extend
	set(value):
		max_mana_extend = value
var current_mana : float
#endregion

@export_group("Unlockables")
@export var is_doublejump_unlock : bool = false
@export var is_dash_unlock : bool = false
