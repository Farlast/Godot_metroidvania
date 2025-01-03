extends EnemyState
class_name EnemyIdle

func on_enter()->void:
	super.on_enter()
	animator.play("idle")
	if owner.has_method("on_idle_enter"):
		owner.on_idle_enter(self)
	
func on_exit()->void:
	super.on_exit()

func on_update(_delta : float)->void:
	super.on_update(_delta)
	if owner.has_method("on_idle"):
		owner.on_idle(self,_delta)

func on_physics_update(_delta : float)->void:
	if owner.has_method("on_idle_physics"):
		owner.on_idle_physics(self,_delta)
	super.on_physics_update(_delta)
