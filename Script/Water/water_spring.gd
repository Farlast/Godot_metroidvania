class_name WaterSpring extends Node2D

signal splash(index:int,speed:float)

@onready var area_2d :Area2D= $Area2D
@onready var collision_shape_2d :CollisionShape2D= $Area2D/CollisionShape2D

var force :float
var height : float
var target_height : float
var velocity :float= 0
var index :int= 0
var motion_factor :float= 0.02
var collider_with :Node2D

func initalize(x_position:float,_index:int)->void:
	height = position.y
	target_height = position.y
	velocity = 0
	position.x = x_position
	index = _index

func set_collision_width(value:float)->void:
	var extend := collision_shape_2d.shape as RectangleShape2D
	var new_extend := Vector2(value,extend.size.y)
	collision_shape_2d.shape.size = new_extend

func wave_update(spring_constance:float,damping:float)->void:
	height = position.y
	var offset :float= height - target_height
	var loss :float= -damping * velocity
	force = -spring_constance * offset + loss
	velocity += force
	position.y += velocity

func _on_area_2d_body_entered(body:Node2D)->void:
	if body == collider_with: return
	collider_with = body
	if body is CharacterBody2D :
		var speed :float= body.velocity.y * motion_factor
		splash.emit(index,speed)

func _on_area_2d_body_exited(_body:Node2D)->void:
	collider_with = null
