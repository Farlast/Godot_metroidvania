extends Area2D

@onready var animator : AnimationPlayer = $AnimationPlayer

func _ready():
	body_entered.connect(_on_area_2d_body_entered)

func _on_area_2d_body_entered(_body):
	animator.play("fade")

func _on_area_2d_body_exited(_body):
	animator.play_backwards("fade")
