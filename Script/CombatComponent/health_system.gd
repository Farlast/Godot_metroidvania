class_name HealthSystem
extends Resource

signal dead

@export var health : StatusValue = StatusValue.new()
@export var poise : StatusValue = StatusValue.new()
@export var status_list : Dictionary # string StatusValue

func setup()->void:
	health.setup()
	poise.setup()
	health.ReachZero.connect(func()->void:dead.emit())

func calculate_damage(damage_data:DamageData)->void:
	health.substrect(damage_data.damage)
	poise.add(damage_data.impact)
