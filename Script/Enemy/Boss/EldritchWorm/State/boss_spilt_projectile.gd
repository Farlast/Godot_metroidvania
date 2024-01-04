extends EnemyState
class_name BossSplitProjectile

var boss : EldritchWorm

func _ready():
	boss = agent as EldritchWorm

func on_enter():
	animator.play("split_projectile")
	await animator.animation_finished
	transition.emit(self,"idle")

func on_exit():
	pass

func on_update(_delta : float):
	pass

func on_physics_update(_delta : float):
	pass
