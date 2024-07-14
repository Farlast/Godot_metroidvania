class_name PlayerData
extends NodeSaveData

### For save system and share data between scene

#region Health
@export_group("Health")
@export var max_health : float = 3:
	get:
		return max_health + max_health_extend
@export var max_health_extend : float = 0:
	get:
		return max_health_extend
	set(value):
		max_health_extend = value
		if value < 0:
			max_health_extend = 0
@export var current_health : float:
	get:
		return current_health
	set(value):
		current_health = value
		if current_health < 0:
			current_health = 0
		if current_health > max_health:
			max_health = value
#endregion

#region Mana
@export var max_mana : float = 5:
	get:
		return max_mana + max_mana_extend
@export var max_mana_extend : float:
	get:
		return max_mana_extend
	set(value):
		max_mana_extend = value
@export var current_mana : float:
	get:
		return current_mana
	set(value):
		current_mana = value
		if current_mana > max_mana:
			current_mana = max_mana
#endregion

#region Unlocks
@export_group("Unlocks")
@export var unlock_dict : Dictionary # [string,bool]

@export_group("start position")
@export var last_scene_visit_path : String

func unlock_abilities(name : String)->void:
	if unlock_dict.has(name):
		unlock_dict[name] = true

func is_abilitie_unlock(key : String)->bool:
	if not unlock_dict.has(key): return false
	return unlock_dict[key]

func clear_all_unlock()->void:
	for key:String in unlock_dict:
		unlock_dict[key] = false
#endregion

func replace_data(data : PlayerData)->void:
	current_health = data.current_health
	max_health = data.max_health
	max_health_extend = data.max_health_extend
	
	max_mana = data.max_mana
	max_mana_extend = data.max_mana_extend
	current_mana = data.current_mana
	
	position = data.position
	last_scene_visit_path = data.last_scene_visit_path
	
	unlock_dict = data.unlock_dict.duplicate()
