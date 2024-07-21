extends EnemyState
class_name StanceBreak

@export var stunt_time: float = 1
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
	timer = 0

func on_update(_delta : float)->void:
	super.on_update(_delta)
	timer += _delta
	if timer > stunt_time:
		next_state()

func on_physics_update(delta : float)->void:
	super.on_physics_update(delta)
	agent.velocity.x = move_toward(agent.velocity.x,0,120)
	agent.velocity.y = move_toward(agent.velocity.y,0,120)

func next_state()->void:
	agent.health_system.stance.add(agent.health_system.stance.max_value)
	agent.stagger_bar.update_hp(agent.health_system.stance.current_value,
	agent.health_system.stance.max_value)
	if not state_active: return
	agent.state_machine.current_state.transition.emit(self,"idle")

func on_take_damage(damage_data:DamageData)->void:
	if not state_active: return
	var get_hit_direction : Vector2
	get_hit_direction = (damage_data.sender_position - agent.global_position).normalized()
	get_hit_direction.x = round_custom(get_hit_direction.x)
	agent.velocity.x = -get_hit_direction.x * knockback_force
	
func round_custom(value:float) -> float:
	if value > 0 : 
		return 1
	else: 
		return -1
