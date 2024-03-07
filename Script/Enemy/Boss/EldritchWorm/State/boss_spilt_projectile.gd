extends EnemyState
class_name BossSplitProjectile

@onready var bullet_scene : PackedScene = preload("res://Scenes/Effect/bullet_physic.tscn")
@export var bullet_amount : float = 5
@export var mouth : Node2D

var boss : EldritchWorm

func _ready():
	super._ready()
	boss = agent as EldritchWorm

func on_enter():
	animator.play("split_projectile")
	await animator.animation_finished
	transition.emit(self,"idle")

func on_exit():
	pass

func on_update(_delta : float):
	pass

func on_physics_update(_delta : float):
	pass

func spawn_bullet():
	var offset : float = 1000 / bullet_amount
	var current_x : float = -500
	for i in bullet_amount:
		var bullet_ins := bullet_scene.instantiate() as BulletPhysic	
		bullet_ins.setup(mouth.global_position, Vector2(current_x, -500))
		current_x += offset
		add_sibling.call_deferred(bullet_ins)
