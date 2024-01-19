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

@onready var sprite : Sprite2D = $Sprite2D
@onready var hurtbox : Area2D  = $HurtBox

func _ready():
	hp = max_hp

func take_damage(damage_data: DamageData):
	hp -= damage_data.damage
	hit_effect.rotation = get_angle_to(damage_data.sender_position) + PI
	hit_effect.restart()
	slash_effect.restart()
	hit_sound.play()
	if hp <= 0:
		dead()

func dead():
	set_process(false)
	set_physics_process(false)
	dead_sound.play()
	sprite.hide()
	hurtbox.set_deferred("monitoring", false)
	dead_effect.restart()
	await get_tree().create_timer(1.5).timeout
	queue_free()
