extends Node2D

signal splash(index,speed)

@onready var area_2d = $Area2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D

var force :float
var height : float
var target_height : float
var velocity = 0
var index = 0
var motion_factor = 0.02
var collider_with :Node2D

func initalize(x_position,_index):
	height = position.y
	target_height = position.y
	velocity = 0
	position.x = x_position
	index = _index

func set_collision_width(value):
	var extend = collision_shape_2d.shape as RectangleShape2D
	var new_extend = Vector2(value,extend.size.y)
	collision_shape_2d.shape.size = new_extend

func wave_update(spring_constance,damping):
	height = position.y
	var offset = height - target_height
	var loss = -damping * velocity
	force = -spring_constance * offset + loss
	velocity += force
	position.y += velocity

func _on_area_2d_body_entered(body):
	if body == collider_with: return
	collider_with = body
	if body is CharacterBody2D :
		var speed = body.velocity.y * motion_factor
		splash.emit(index,speed)


func _on_area_2d_body_exited(_body):
	collider_with = null
