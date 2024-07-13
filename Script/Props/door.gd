extends StaticBody2D
class_name Door

@export var trigger : TriggerSwitch
@export var open : bool = false

@onready var animation : AnimationPlayer = $AnimationPlayer

var opening : bool = false

func _ready():
	if open:
		animation.play("open")
	if trigger: trigger.switch_triggered.connect(on_triggered)

func on_triggered():
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
