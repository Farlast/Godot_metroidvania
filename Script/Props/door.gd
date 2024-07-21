extends StaticBody2D
class_name Door

@export var trigger : TriggerSwitch
@export var open : bool = false

@onready var animation : AnimationPlayer = $AnimationPlayer

var opening : bool = false

func _ready()->void:
	if open:
		animation.play("open")
	if trigger: trigger.switch_triggered.connect(on_triggered)

func on_triggered()->void:
	if opening: return
	opening = true
	if not open:
		open = true
		animation.play("open")
	else:
		open = false
		animation.play("close")
	await animation.animation_finished
	opening = false
