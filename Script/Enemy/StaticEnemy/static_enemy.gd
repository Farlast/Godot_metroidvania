extends StaticBody2D
class_name StaticEnemy

@export var max_hp : float
var hp : float

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var hit_sound : AudioStreamPlayer2D = $Audio/HitSound
@onready var dead_sound : AudioStreamPlayer2D = $Audio/DeadSound

@onready var hit_effect : CPUParticles2D = $Particle/HitEffect
@onready var slash_effect : CPUParticles2D = $Particle/SlashEffect
@onready var dead_effect : GPUParticles2D = $Particle/DeadParticle

@onready var direction_holder : Node2D = $Direction
@onready var sprite : Sprite2D = $Direction/Sprite2D
@onready var hurtbox : Area2D  = $HurtBox

var shader : ShaderMaterial
var flashing : bool = false
var flashing_duration : float = 0.2
var flashing_timer : float

func _ready()->void:
	hp = max_hp
	shader = sprite.material as ShaderMaterial

func _process(delta:float)->void:
	flash_on_hit(delta)

func flash_on_hit(delta:float)->void:
	if flashing:
		flashing_timer += delta
		if flashing_timer >= flashing_duration:
			flashing_timer = 0
			flashing = false
		shader.set_shader_parameter("active",true)
	else:
		shader.set_shader_parameter("active",false)

func take_damage(damage_data: DamageData)->bool:
	var is_hit:bool = calculate_damage(damage_data)
	if is_hit:
		hit_effect.rotation = get_angle_to(damage_data.sender_position) + PI
		hit_effect.restart()
		slash_effect.restart()
		hit_sound.play()
	return is_hit

func calculate_damage(damage_data: DamageData)->bool:
	hp -= damage_data.damage
	if hp <= 0:
		hp = 0
		dead()
	return true

func dead()->void:
	set_process(false)
	set_physics_process(false)
	dead_sound.play()
	sprite.hide()
	hurtbox.set_deferred("monitoring", false)
	dead_effect.restart()
	await get_tree().create_timer(1.5).timeout
	queue_free()

func flip_direction(target_pos : Vector2)->void:
	if target_pos > global_position:
		direction_holder.scale.x = abs(direction_holder.scale.x)
	else:
		direction_holder.scale.x = -abs(direction_holder.scale.x)
