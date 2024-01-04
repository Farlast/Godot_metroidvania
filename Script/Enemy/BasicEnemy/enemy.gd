extends CharacterBody2D
class_name Enemy

signal on_dead

@export var health : float = 3
@export var gravity_multiply :float = 2.5
@export var stagger_duration : float = 0.3

@onready var hit_sound : AudioStreamPlayer2D = $Audio/HitSound
@onready var dead_sound : AudioStreamPlayer2D = $Audio/DeadSound
@onready var animator : AnimationPlayer = $AnimationPlayer

@export_group("Particle")
@onready var hit_effect : CPUParticles2D = $Particle/HitEffect
@onready var slash_effect : CPUParticles2D = $Particle/SlashEffect
@onready var dead_particle : GPUParticles2D = $Particle/DeadParticle
@onready var pulse_particle : GPUParticles2D = $Particle/Pulse

@export_group("Area2D")
@onready var hitbox : CollisionShape2D = $AttackBox/CollisionShape2D
@onready var hurtbox : CollisionShape2D = $HurtBox/CollisionShape2D
@onready var collion : CollisionShape2D = $GroundCollision

@onready var state_machine : EnemyStateMachine = $EnemyStateMachine
@onready var on_screen : VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

@onready var direction_holder : Node2D = $Directions

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var get_hit_direction : Vector2

func take_damage(damage_data : DamageData):
	health -= damage_data.damage
	hit_effect.rotation = get_angle_to(damage_data.sender_position) + PI
	hit_effect.restart()
	slash_effect.restart()
	hit_sound.play()
	if health <= 0:
		dead()
	else :
		get_hit_direction = (damage_data.sender_position - global_position).normalized()
		state_machine.current_state.transition.emit(state_machine.current_state,"stagger")
	
func add_gravity(delta):
	if not is_on_floor() :
		velocity.y += gravity * gravity_multiply * delta

func dead():
	animator.play("dead")
	dead_sound.play()
	dead_particle.restart()
	pulse_particle.restart()
	set_process(false)
	set_physics_process(false)
	state_machine.set_process(false)
	state_machine.set_physics_process(false)
	hitbox.set_deferred("disabled",true)
	hurtbox.set_deferred("disabled",true)
	collion.set_deferred("disabled",true)
	on_dead.emit()
	await get_tree().create_timer(1.5).timeout
	queue_free()

func on_idle(_state : EnemyState):
	pass

func flip_direction():
	direction_holder.scale.x = -direction_holder.scale.x
