extends Control

@export var display_event : CustomEventChannel
@onready var lable : Label = $Label
@onready var button : Button = $Button

var exit : bool = false

func _ready():
	hide()
	lable.text =""
	display_event.string_event_sended.connect(display_text)
	pivot_offset = size/2

func display_text(text : String):
	show()
	button.grab_focus()
	lable.text = text
	var final_scale : Vector2 = Vector2(0.7,0.7)
	scale = final_scale
	var tween = get_tree().create_tween()
	tween.set_ease(tween.EASE_IN_OUT)
	tween.tween_property(self,"scale",Vector2.ONE,0.05)
	GameManager.time_manager.freeze()

func hide_layout():
	GameManager.time_manager.unfreeze()
	if exit: return
	var tween = get_tree().create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.tween_property(self,"scale",Vector2(0.7,0.7),0.05)
	await tween.finished
	hide()
	
func _exit_tree():
	exit = true
