class_name ElementalDisplay
extends Node2D

@export var speed : float = 3
@export var water : Texture2D
@export var wood : Texture2D
@export var fire : Texture2D

var  lerp_target : Node2D

func setup(start_position : Vector2, target : Node2D, element : ElementData.ElementType):
	show()
	global_position = start_position
	lerp_target = target
	match element:
		ElementData.ElementType.WATER:
			$Sprite2D.texture = water
		ElementData.ElementType.POISON:
			$Sprite2D.texture = wood
		ElementData.ElementType.FIRE:
			$Sprite2D.texture = fire
		_:
			$Sprite2D.texture = water

func _physics_process(delta):
	if lerp_target == null: return
	global_position = lerp(global_position,lerp_target.global_position, speed * delta)

func set_display_off():
	hide()
	#lerp_target = null
	#queue_free()
