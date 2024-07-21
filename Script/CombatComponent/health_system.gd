class_name HealthSystem
extends Resource

signal stance_break
signal dead

@export var health : StatusValue
@export var stance : StatusValue

func setup()->void:
	health.setup()
	health.ReachZero.connect(func()->void:dead.emit())
	stance.setup()
	stance.ReachZero.connect(func()->void:stance_break.emit())

func calculate_damage(damage_data:DamageData)->void:
	health.substrect(damage_data.damage)
	stance.substrect(damage_data.impact)

func is_dead()-> bool:
	return health.current_value <= 0
