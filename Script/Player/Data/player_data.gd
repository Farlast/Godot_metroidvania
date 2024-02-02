class_name PlayerData
extends NodeSaveData

@export_group("Health")
#region Health
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
		if value < 0:
			current_health = 0
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

@export_group("Unlockables")
@export var is_doublejump_unlock : bool = false
@export var is_dash_unlock : bool = false

@export_group("start position")
@export var last_scene_visit_path : String

@export_group("skill")
@export var orb_status : SkillSystem.OrbStatus
@export var current_orb_element : ElementData.ElementType
@export var current_used_element : ElementData.ElementType

func replace_data(data : PlayerData):
	current_health = data.current_health
	max_health = data.max_health
	max_health_extend = data.max_health_extend
	
	max_mana = data.max_mana
	max_mana_extend = data.max_mana_extend
	current_mana = data.current_mana
