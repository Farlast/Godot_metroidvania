class_name RampAttack
extends EnemyState

@onready var cliff_ray : RayCast2D = $"../../Direction/DownRay"
@export var attack_box_col : CollisionShape2D
@export var ramp_speed : float = 800

var active_state : bool

func on_enter()->void:
	active_state = true
	agent.velocity.x = 0
	animator.animation_finished.connect(on_animation_finish)
	animator.play("ramp_attack")
	agent.super_armor = true

func on_exit()->void:
	super.on_exit()
	## allow interrup by break stance
	agent.super_armor = false
	active_state = false
	attack_box_col.set_deferred("disabled",true)
	animator.animation_finished.disconnect(on_animation_finish)

func start_attack()->void:
	agent.velocity.x = ramp_speed * -agent.direction_holder.scale.x
	attack_box_col.set_deferred("disabled",false)

func stop_attack()->void:
	agent.super_armor = false
	attack_box_col.set_deferred("disabled",true)

func on_animation_finish(_animation_name : String)->void:
	if active_state and _animation_name == "ramp_attack":
		transition.emit(self,"idle")

func on_update(delta:float)->void:
	super.on_update(delta)
	if not cliff_ray.is_colliding() and active_state:
		stop_attack()
		transition.emit(self,"idle")

func on_physics_update(delta : float)->void:
	super.on_physics_update(delta)
	agent.velocity.x = move_toward(agent.velocity.x,0,30)
