extends Node2D
class_name Destroyable

@export var max_hp : float = 1
@export var object_free_time : float = 1
@onready var hit_effect : CPUParticles2D = $hit_effect
@onready var slash_effect : CPUParticles2D = $slash_effect
@onready var art : Sprite2D = $Art
@onready var hurt_box_col : CollisionShape2D = $HurtBox/CollisionShape2D

var hp : float

func _ready()->void:
	hp = max_hp

func take_damage(damage_data : DamageData)->bool:
	hp -= damage_data.damage
	play_effect_on_hit()
	if hp <= 0:
		art.visible = false
		clear_on_dead()
		await get_tree().create_timer(object_free_time).timeout
		queue_free()
	return true
	
func play_effect_on_hit()->void:
	hit_effect.restart()
	slash_effect.restart()

func clear_on_dead()->void:
	hurt_box_col.set_deferred("disabled",true)
