extends EnemyState

var boss : CrabKing

func _ready():
	boss = agent as CrabKing

func on_enter():
	animator.play("idle")

func on_exit():
	pass

func on_update(_delta : float):
	if boss.ray.is_colliding():
		boss.room_trigger.switch_triggered.emit()
		boss.target = boss.ray.get_collider() as Node2D
		transition.emit(self,"idle")
