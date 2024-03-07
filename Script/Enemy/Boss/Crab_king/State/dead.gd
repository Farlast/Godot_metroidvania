extends EnemyState

var boss : CrabKing

func _ready():
	boss = agent as CrabKing

func on_enter():
	animator.play("dead")

func on_exit():
	pass
