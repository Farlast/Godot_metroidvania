extends EnemyState
class_name EnemyStandby

var boss : EldritchWorm

func _ready():
	super._ready()
	boss = agent as EldritchWorm

func on_enter():
	animator.play("standby")

func on_exit():
	pass

func on_update(_delta : float):
	if boss.front_ray.is_colliding():
		boss.room_trigger.switch_triggered.emit()
		boss.target = boss.front_ray.get_collider() as Node2D
		transition.emit(self,"idle")

func on_physics_update(_delta : float):
	pass
