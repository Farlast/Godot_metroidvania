class_name HealthSystem
extends Resource

signal stance_break
signal dead

@export var health : StatusValue
@export var stance : StatusValue

func setup():
	health.setup()
	health.ReachZero.connect(func():dead.emit())
	stance.setup()
	stance.ReachZero.connect(func():stance_break.emit())

func calculate_damage(damage_data:DamageData):
	health.substrect(damage_data.damage)
	stance.substrect(damage_data.impact)

func is_dead()-> bool:
	return health.current_value <= 0
