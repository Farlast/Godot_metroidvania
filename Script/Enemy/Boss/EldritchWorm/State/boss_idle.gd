extends EnemyState
class_name BossIdle

var boss : EldritchWorm

func _ready():
	boss = agent as EldritchWorm

func on_enter():
	animator.play("idle")
	await get_tree().create_timer(1.0).timeout
	transition.emit(self,"dig_underground")

func on_exit():
	pass

func on_update(_delta : float):
	pass

func on_physics_update(_delta : float):
	pass

func random_move():
	var ran_range = randi_range(0,1)
	if ran_range > 0 :
		transition.emit(self,"dig_underground")
	else:
		transition.emit(self,"split_projectile")
