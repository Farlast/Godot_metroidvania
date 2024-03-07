class_name CrabKing
extends CharacterBody2D

signal on_dead

@export var health : float = 20
@export var room_trigger : TriggerSwitch

@onready var animator : AnimationPlayer = $AnimationPlayer
@onready var hit_sound : AudioStreamPlayer2D = $Audio/HitSound
@onready var dead_sound : AudioStreamPlayer2D = $Audio/DeadSound

@onready var hitbox : CollisionShape2D = $AttackBox/CollisionShape2D
@onready var hurtbox : CollisionShape2D = $HurtBox/CollisionShape2D
@onready var collion : CollisionShape2D = $GroundCollision
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine

#@export_group("Particle")
@onready var hit_effect : CPUParticles2D = $Particle/HitEffect
@onready var slash_effect : CPUParticles2D = $Particle/SlashEffect
@onready var dead_particle : GPUParticles2D = $Particle/DeadParticle
@onready var pulse_particle : GPUParticles2D = $Particle/Pulse

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var gravity_multiply :float = 2.5

@export var ray : RayCast2D
var get_hit_direction : Vector2
var target : Node2D
var shader : ShaderMaterial


func _ready():
	shader = $Sprite2D.material as ShaderMaterial

func take_damage(damage_data : DamageData):
	health -= damage_data.damage
	hit_effect.rotation = get_angle_to(damage_data.sender_position) + PI
	hit_effect.restart()
	slash_effect.restart()
	hit_sound.play()
	flash_on_hit()
	
	if health <= 0:
		dead()
	else :
		get_hit_direction = (damage_data.sender_position - global_position).normalized()

func dead():
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
	room_trigger.switch_triggered.emit()
	state_machine.current_state.transition.emit(state_machine.current_state,"dead")
	animator.play("dead")
	await animator.animation_finished
	await get_tree().create_timer(1.5).timeout
	queue_free()
	
func flash_on_hit():
	shader.set_shader_parameter("active",true)
	await get_tree().create_timer(0.2).timeout
	shader.set_shader_parameter("active",false)

func add_gravity(delta):
	if not is_on_floor() :
		velocity.y += gravity * gravity_multiply * delta
