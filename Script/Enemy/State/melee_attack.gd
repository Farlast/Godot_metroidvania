class_name MeleeAttack
extends EnemyState

@export var attack_box_col : CollisionShape2D
var active_state : bool

func _ready():
	super._ready()
	animator.animation_finished.connect(on_animation_finish)

func on_enter():
	active_state = true
	agent.velocity.x = 0
	animator.play("melee_attack")

func on_exit():
	## allow interrup by break stance
	active_state = false
	attack_box_col.set_deferred("disabled",true)
	super.on_exit()
	
func on_animation_finish(_animation_name : String):
	if active_state and _animation_name == "melee_attack":
		transition.emit(self,"idle")
	
func on_physics_update(_delta : float):
	if agent.velocity.x > 0:
		agent.velocity.x -= 200 * _delta
	elif agent.velocity.x < 0:
		agent.velocity.x += 200 * _delta
	super.on_physics_update(_delta)
