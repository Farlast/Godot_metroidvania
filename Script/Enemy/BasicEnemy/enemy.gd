extends CharacterBody2D
class_name Enemy

signal on_dead
signal take_damage_trigger(damage_data : DamageData)

@export var health_system : HealthSystem 
@export var gravity_multiply :float = 1

@export_group("Debug")
@export var hp_bar : StatusBar
@export var stagger_bar : StatusBar
## audio
@onready var hit_sound : AudioStreamPlayer2D = $Audio/HitSound
@onready var dead_sound : AudioStreamPlayer2D = $Audio/DeadSound
## Particle
@onready var take_damage_effects : EffectEmiter = $Particle/TakeDamageVFX
@onready var dead_effect : EffectEmiter = $Particle/DeadVFX
@onready var hit_effect : CPUParticles2D = $Particle/HitEffect

## Area2D
@onready var hurtbox : CollisionShape2D = $HurtBox/CollisionShape2D
@onready var collision : CollisionShape2D = $GroundCollision

@onready var state_machine : EnemyStateMachine = $EnemyStateMachine
@onready var animator : AnimationPlayer = $AnimationPlayer
@onready var direction_holder : Node2D = $Direction
@onready var sprite : Sprite2D = $Direction/Sprite2D

var gravity :float= ProjectSettings.get_setting("physics/2d/default_gravity")
var get_hit_direction : Vector2
var shader : ShaderMaterial
var flashing_duration : float = 0.1
var super_armor : bool
var target : Node2D

func _ready()->void:
	health_system.setup()
	health_system.dead.connect(dead)
	shader = sprite.material as ShaderMaterial

func take_damage(damage_data : DamageData)->bool:
	var is_hit:bool = calculate_damage(damage_data)
	if is_instance_valid(hp_bar):
		hp_bar.update_hp(health_system.health.current_value,health_system.health.max_value)
	if is_hit:
		flash_on_hit()
		hit_effect.rotation = get_angle_to(damage_data.sender_position) + PI
		hit_effect.restart()
		take_damage_effects.restart_all()
		hit_sound.play()
	return is_hit

func calculate_damage(damage_data : DamageData)-> bool:
	health_system.calculate_damage(damage_data)
	take_damage_trigger.emit(damage_data)
	return true

func knockback(damage_data : DamageData)->void:
	get_hit_direction = (global_position - damage_data.sender_position).normalized()
	if damage_data.knockback_force == DamageData.KnockBackForce.MID:
		velocity.x = get_hit_direction.x * 1000

func flash_on_hit()->void:
	shader.set_shader_parameter("active",true)
	await get_tree().create_timer(flashing_duration).timeout
	shader.set_shader_parameter("active",false)
	
func add_gravity(delta:float)->void:
	if not is_on_floor() :
		velocity.y += gravity * gravity_multiply * delta

func dead()->void:
	GameManager.main_camera.add_clamp_trauma(0.5)
	animator.play("dead")
	dead_sound.play()
	dead_effect.restart_all()
	set_process(false)
	set_physics_process(false)
	state_machine.set_process(false)
	state_machine.set_physics_process(false)
	hurtbox.set_deferred("disabled",true)
	collision.set_deferred("disabled",true)
	on_dead.emit()
	await get_tree().create_timer(1.5).timeout
	queue_free()

func on_idle(_state : EnemyState,_delta:float)->void:
	pass

func flip_direction()->void:
	direction_holder.scale.x = -direction_holder.scale.x

func add_drag(delta : float, drag : float = 5)->void:
	velocity.x = move_toward(velocity.x,0,delta * drag)
