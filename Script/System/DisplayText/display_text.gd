extends CanvasLayer
class_name DisplayText

@export var display_event : CustomEventChannel
@onready var lable : RichTextLabel = $DisplayLayout/Label
@onready var layout : Control = $DisplayLayout

var exit : bool = false

func _ready()->void:
	lable.text =""
	hide()
	display_event.string_event_sended.connect(display_text)
	display_event.void_event_sended.connect(hide_layout)

func display_text(text : String)->void:
	show()
	lable.text = text
	layout.position.y -= 200
	var final_position : Vector2 = layout.position
	final_position.y = 0
	var tween :Tween= get_tree().create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.tween_property(layout,"position",final_position,0.3)

func  hide_layout()->void:
	if exit: return
	var final_position : Vector2 = layout.position
	final_position.y -= 200
	var tween :Tween= get_tree().create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.tween_property(layout,"position",final_position,0.3)
	await tween.finished
	hide()
	
func _exit_tree()->void:
	exit = true
