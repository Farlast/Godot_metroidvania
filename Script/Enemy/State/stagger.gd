extends EnemyState
class_name Stagger

@export var stagger_duration : float = 1
@export var knockback_force : float = 800
var timer : float

func _ready()->void:
	if owner.has_signal("take_damage_trigger"):
		owner.take_damage_trigger.connect(on_take_damage)

func _exit_tree()->void:
	if owner.has_signal("take_damage_trigger"):
		owner.take_damage_trigger.disconnect(on_take_damage)

func on_enter()->void:
	super.on_enter()
	agent.velocity = Vector2.ZERO
	timer = 0
	animator.play("stagger")

func on_exit()->void:
	super.on_exit()

func on_update(_delta : float)->void:
	super.on_update(_delta)
	timer += _delta
	if timer > stagger_duration:
		transition.emit(self,"idle")

func on_physics_update(delta : float)->void:
	super.on_physics_update(delta)
	agent.velocity.x = move_toward(agent.velocity.x,0,120)

func on_take_damage(damage_data:DamageData)->void:
	if not state_active: return
	var get_hit_direction : Vector2
	get_hit_direction = (damage_data.sender_position - agent.global_position).normalized()
	get_hit_direction.x = round_custom(get_hit_direction.x)
	agent.velocity.x = -get_hit_direction.x * knockback_force
	
func round_custom(value:float) -> float:
	if value > 0:return 1
	else:return -1
