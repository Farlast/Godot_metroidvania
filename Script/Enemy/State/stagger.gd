extends EnemyState
class_name Stagger

@export var stagger_duration : float = 1
@export var knockback_force_low : float = 200
@export var knockback_force_mid : float = 400
@export var knockback_force_high : float = 800

var timer : float
var get_hit_direction : Vector2

func _ready()->void:
	if owner.has_signal("take_damage_trigger"):
		owner.take_damage_trigger.connect(on_take_damage)

func _exit_tree()->void:
	if owner.has_signal("take_damage_trigger"):
		owner.take_damage_trigger.disconnect(on_take_damage)

func on_enter()->void:
	super.on_enter()
	timer = 0
	state_active = true
	agent.velocity.x = get_hit_direction.x * knockback_force_low
	animator.play("stagger")

func on_exit()->void:
	state_active = false
	super.on_exit()

func on_update(_delta : float)->void:
	super.on_update(_delta)
	timer += _delta
	if timer > stagger_duration:
		transition.emit(self,"idle")

func on_physics_update(delta : float)->void:
	super.on_physics_update(delta)
	agent.velocity.x = move_toward(agent.velocity.x,0,15)

func on_take_damage(damage_data:DamageData)->void:
	get_hit_direction = (agent.global_position - damage_data.sender_position).normalized()
	if not state_active: return
	var knockback_force : float
	match damage_data.knockback_force:
		DamageData.KnockBackForce.LOW:
			knockback_force = knockback_force_low
		DamageData.KnockBackForce.MID:
			knockback_force = knockback_force_mid
		DamageData.KnockBackForce.HEAVY:
			knockback_force = knockback_force_high
	agent.velocity.x = get_hit_direction.x * knockback_force
