extends StaticEnemy
class_name LivingVine

@onready var attack_box : CollisionShape2D = $Direction/AttackBox/AttackArea
@onready var contact_box : CollisionShape2D = $Direction/contack/AttackArea
@onready var ray : RayCast2D = $RayCast2D

enum ActionState { Idle, Attack }

@export var attack_cooldown_duration : float = 1.0
var attack_cooldown_timer : float = 0
var currentState : ActionState

func _ready():
	super._ready()
	currentState = ActionState.Idle

func take_damage(damage_data: DamageData)->bool:
	flashing = true
	return	super.take_damage(damage_data)

func dead():
	animation_player.play("idle")
	attack_box.set_deferred("disabled",true)
	contact_box.set_deferred("disabled",true)
	super.dead()

func _process(delta):
	flash_on_hit(delta)
	state_calculate(delta)
#region State

func state_calculate(delta):
	match currentState:
		ActionState.Idle:
			on_idle(delta)
		ActionState.Attack:
			on_attack(delta)

func on_idle(delta):
	if ray.is_colliding():
		attack_cooldown_timer += delta
		if attack_cooldown_timer > attack_cooldown_duration:
			currentState = ActionState.Attack
			var target = ray.get_collider() as Node2D
			flip_direction(target.global_position)

func on_attack(_delta):
	$AnimationPlayer.play("attack")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("idle")
	currentState = ActionState.Idle
	attack_cooldown_timer = 0
	
#endregion
