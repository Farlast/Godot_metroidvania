class_name HealthSystem
extends Resource

signal stance_break
signal dead

@export var health : StatusValue
@export var stance : StatusValue

func setup():
	health.setup()
	stance.setup()
	health.ReachZero.connect(func():dead.emit())
	stance.ReachZero.connect(func():stance_break.emit())

func calculate_damage(damage_data:DamageData):
	health.substrect(damage_data.damage)
	stance.substrect(damage_data.impact)
