extends EnemyState
class_name ChaseState

func on_enter():
	animator.play("chase")
	pass

func on_exit():
	pass

func on_update(_delta : float):
	if owner.has_method("on_chase"):
		owner.on_chase(self,_delta)

func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
