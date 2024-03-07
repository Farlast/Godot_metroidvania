extends EnemyState

var boss : CrabKing

func _ready():
	boss = agent as CrabKing

func on_enter():
	animator.play("idle")

func on_exit():
	pass

func on_update(_delta : float):
	# random move
	if boss.target:
		transition.emit(self,"attack")
