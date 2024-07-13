class_name GrabbableHost extends Area2D

@onready var animator :AnimationPlayer = $AnimationPlayer
@export var grabbable : Grabbable
@export var refill_time : float = 5
var havested : bool

func can_havest()->bool:
	return not havested

func get_object()-> Grabbable:
	if not havested:
		get_tree().create_timer(refill_time).timeout.connect(refill)
		havested = true
		animator.play("havest")
	return grabbable

func refill():
	animator.play("idle")
	havested = false
