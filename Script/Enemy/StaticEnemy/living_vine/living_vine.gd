extends StaticBody2D
class_name LivingVine

@export var max_hp : float
var hp : float

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var hit_sound : AudioStreamPlayer2D = $Audio/HitSound
@onready var dead_sound : AudioStreamPlayer2D = $Audio/DeadSound

@onready var hit_effect : CPUParticles2D = $Particle/HitEffect
@onready var slash_effect : CPUParticles2D = $Particle/SlashEffect
@onready var dead_effect : GPUParticles2D = $Particle/DeadParticle

@onready var sprite : Sprite2D = $Direction/Sprite2D
@onready var hurtbox : Area2D  = $HurtBox
@onready var attack_box : CollisionShape2D = $Direction/AttackBox/AttackArea
@onready var contack_box : CollisionShape2D = $Direction/contack/AttackArea
@onready var art : Sprite2D = $Direction/Sprite2D
@onready var ray : RayCast2D = $RayCast2D
@onready var direction_holder : Node2D = $Direction

enum ActionState { Idle, Attack }
var shader : ShaderMaterial

var flashing : bool
var flashing_duration : float = 0.2
var flashing_timer : float

@export var attack_cooldown_duration : float = 1.0
var attack_cooldown_timer : float
var currentState : ActionState

func _ready():
	hp = max_hp
	shader = art.material as ShaderMaterial
	currentState = ActionState.Idle

func _process(delta):
	flash_on_hit(delta)
	state_calculate(delta)

func dead():
	animation_player.play("RESET")
	attack_box.set_deferred("disabled",true)
	contack_box.set_deferred("disabled",true)
	set_process(false)
	set_physics_process(false)
	dead_sound.play()
	sprite.hide()
	hurtbox.set_deferred("monitoring", false)
	dead_effect.restart()
	await get_tree().create_timer(1.5).timeout
	queue_free()

func take_damage(damage_data: DamageData):
	hp -= damage_data.damage
	flashing = true
	hit_effect.rotation = get_angle_to(damage_data.sender_position) + PI
	hit_effect.restart()
	slash_effect.restart()
	hit_sound.play()
	if hp <=0:
		dead()
	
func flash_on_hit(delta):
	if flashing:
		flashing_timer += delta
		if flashing_timer >= flashing_duration:
			flashing_timer = 0
			flashing = false
		shader.set_shader_parameter("active",true)
	else:
		shader.set_shader_parameter("active",false)

func state_calculate(delta):
	match currentState:
		ActionState.Idle:
			on_idle(delta)
		ActionState.Attack:
			on_attack(delta)

func on_idle(delta):
	if ray.is_colliding() and attack_cooldown_timer > attack_cooldown_duration:
		currentState = ActionState.Attack
		var target = ray.get_collider() as Node2D
		flip_direction(target.global_position)
	attack_cooldown_timer += delta

func on_attack(_delta):
	$AnimationPlayer.play("attack")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("idle")
	currentState = ActionState.Idle
	attack_cooldown_timer = 0
	
func flip_direction(target_pos : Vector2):
	if target_pos > global_position:
		direction_holder.scale.x = abs(direction_holder.scale.x)
	else:
		direction_holder.scale.x = -abs(direction_holder.scale.x)
