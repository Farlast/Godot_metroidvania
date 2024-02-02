extends Area2D
class_name Bullet

@onready var attack_box_col : CollisionShape2D = $AttackBox/CollisionShape2D
@onready var attack_box : AttackBox = $AttackBox

var direction : Vector2
var speed : float = 800
var stop : bool
var attack_mask : DamageData.DamageMask

func _ready():
	stop = false
	attack_box.damage_data.take_damage_mask = attack_mask
	#DamageData.DamageMask

func take_damage(_damage:DamageData):
	on_free()

func grounded(_body):
	on_free()

func _physics_process(delta):
	if not stop:
		global_position += direction * (speed * delta)
	
func on_free():
	stop = true
	attack_box_col.set_deferred("disabled",true)
	$AnimationPlayer.play("destory")
	await $AnimationPlayer.animation_finished
	queue_free()
