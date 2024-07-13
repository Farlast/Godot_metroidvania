extends EnemyState

@export var on_floor : EnemyState
@export var jump_velocity : Vector2

var delay :float = 0.3
var timer :float

func on_enter():
	super.on_enter()
	animator.play("jump")
	timer = 0
	agent.velocity.x = agent.direction_holder.scale.x * jump_velocity.x
	agent.velocity.y = jump_velocity.y

func on_exit():
	super.on_exit()

func on_update(_delta : float):
	if leave_ground(_delta):
		if agent.is_on_floor():
			transition.emit(self,on_floor.name)

func on_physics_update(_delta : float):
	agent.add_gravity(_delta)
	agent.move_and_slide()

func leave_ground(delta)->bool:
	timer += delta
	return timer > delay
