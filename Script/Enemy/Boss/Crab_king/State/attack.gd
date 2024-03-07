extends EnemyState

var boss : CrabKing

func _ready():
	boss = agent as CrabKing

func on_enter():
	animator.play("attack")
	await animator.animation_finished
	transition.emit(self,"idle")

func on_exit():
	pass
