extends Area2D
class_name Bullet

@onready var attack_box : CollisionShape2D = $AttackBox/CollisionShape2D

func _ready():
	body_entered.connect(grounded)

func _physics_process(delta):
	global_position += gravity_direction * (gravity * delta)

func take_damage(_damage:DamageData):
	on_free()

func grounded(_body):
	on_free()
	
func on_free():
	gravity = 0
	set_physics_process(false)
	attack_box.set_deferred("disabled",true)
	$AnimationPlayer.play("destory")
	await $AnimationPlayer.animation_finished
	queue_free()
