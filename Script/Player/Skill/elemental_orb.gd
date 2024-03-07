class_name ElementalOrb
extends Area2D

signal send_element(element : ElementData, contact_position : Vector2)

@export var move_speed : float = 800
@export var life_time : float = 0.5
var direction : Vector2
var moving : bool

func _ready():
	moving = true
	area_entered.connect(get_element)
	$AnimationPlayer.play("idle")
	await get_tree().create_timer(life_time).timeout
	destory()

func get_element(body : Area2D):
	if body is ElementBox:
		var element_obj = body as ElementBox
		send_element.emit(element_obj.element_data,global_position)
		destory()

func ground_contact(_body : Node2D):
	destory()
	
func destory():
	moving = false
	$Particles2D.set_deferred("emitting",false)
	$AnimationPlayer.play("pop")
	await $AnimationPlayer.animation_finished
	queue_free()

func _physics_process(delta):
	if not moving: return
	global_position += direction * (move_speed * delta)
