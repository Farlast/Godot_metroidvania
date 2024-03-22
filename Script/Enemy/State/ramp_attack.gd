class_name RampAttack
extends EnemyState

@export var attack_box_col : CollisionShape2D
@export var deceleration_rate : float = 500
var active_state : bool

func _ready():
	super._ready()
	animator.animation_finished.connect(on_animation_finish)

func on_enter():
	agent.super_armor = true
	active_state = true
	agent.velocity.x = 0
	animator.play("ramp_attack")

func on_exit():
	super.on_exit()
	## allow interrup by break stance
	agent.super_armor = false
	active_state = false
	attack_box_col.set_deferred("disabled",true)

func start_attack():
	agent.velocity.x = 500 * -agent.direction_holder.scale.x
	attack_box_col.set_deferred("disabled",false)

func stop_attack():
	attack_box_col.set_deferred("disabled",true)

func on_animation_finish(_animation_name : String):
	if active_state and _animation_name == "ramp_attack":
		transition.emit(self,"idle")
	
func on_physics_update(_delta : float):
	if agent.velocity.x > 0:
		agent.velocity.x -= deceleration_rate * _delta
	elif agent.velocity.x < 0:
		agent.velocity.x += deceleration_rate * _delta
	super.on_physics_update(_delta)
