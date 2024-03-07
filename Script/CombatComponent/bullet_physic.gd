class_name BulletPhysic
extends RigidBody2D

@onready var ground_check : Area2D = $ground
var life_time : float = 5
var freeing : bool = false

func _ready():
	ground_check.body_entered.connect(on_grounded)
	await get_tree().create_timer(life_time).timeout
	if not freeing :
		freeing = true
		on_destory()

func setup(start_position : Vector2,vector : Vector2):
	global_position = start_position
	apply_impulse(vector)

func on_grounded(_body):
	if not freeing :
		freeing = true
		on_destory()

func on_destory():
	queue_free()
