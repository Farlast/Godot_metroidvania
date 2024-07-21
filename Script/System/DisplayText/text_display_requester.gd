extends Area2D
class_name TextDisplayRequester

@export var display_event : CustomEventChannel
@export_multiline var text_to_display : String

func _ready()->void:
	connect("body_entered",send_text)
	connect("body_exited",hide_text)

func send_text(_body:Node2D)->void:
	display_event.string_event_sended.emit(text_to_display)

func hide_text(_body:Node2D)->void:
	display_event.void_event_sended.emit()
