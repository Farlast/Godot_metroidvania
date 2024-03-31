extends CharacterBody2D
class_name Enemy

signal on_dead
signal stance_breaked

@export var health_system : HealthSystem 
@export var gravity_multiply :float = 2.5

@onready var hit_sound : AudioStreamPlayer2D = $Audio/HitSound
@onready var dead_sound : AudioStreamPlayer2D = $Audio/DeadSound
@onready var animator : AnimationPlayer = $AnimationPlayer

##@export_group("Particle")
@onready var hit_effect : CPUParticles2D = $Particle/HitEffect
@onready var slash_effect : CPUParticles2D = $Particle/SlashEffect
@onready var dead_particle : GPUParticles2D = $Particle/DeadParticle
@onready var pulse_particle : GPUParticles2D = $Particle/Pulse

##@export_group("Area2D")
@onready var hurtbox : CollisionShape2D = $HurtBox/CollisionShape2D
@onready var collion : CollisionShape2D = $GroundCollision

@onready var state_machine : EnemyStateMachine = $EnemyStateMachine

@onready var direction_holder : Node2D = $Direction
@onready var sprite : Sprite2D = $Direction/Sprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var get_hit_direction : Vector2

var shader : ShaderMaterial
var flashing_duration : float = 0.1
var super_armor : bool

func _ready():
	health_system.setup()
	health_system.dead.connect(dead)
	health_system.stance_break.connect(on_stance_break)
	shader = sprite.material as ShaderMaterial

func take_damage(damage_data : DamageData)->bool:
	var is_hit:bool = calculate_damage(damage_data)
	if is_hit:
		flash_on_hit()
		hit_effect.rotation = get_angle_to(damage_data.sender_position) + PI
		hit_effect.restart()
		slash_effect.restart()
		hit_sound.play()
	return is_hit

func calculate_damage(damage_data : DamageData)-> bool:
	health_system.calculate_damage(damage_data)
	return true

func flash_on_hit():
	shader.set_shader_parameter("active",true)
	await get_tree().create_timer(flashing_duration).timeout
	shader.set_shader_parameter("active",false)
	
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
	hurtbox.set_deferred("disabled",true)
	collion.set_deferred("disabled",true)
	on_dead.emit()
	await get_tree().create_timer(1.5).timeout
	queue_free()

func on_stance_break():
	pass

func on_idle(_state : EnemyState):
	pass

func flip_direction():
	direction_holder.scale.x = -direction_holder.scale.x

func add_drag(delta : float, drag : float = 5):
	if is_on_floor():
		if velocity.x > 0:
			velocity.x -= abs(velocity.x * delta * drag)
		else:
			velocity.x += abs(velocity.x * delta * drag)
