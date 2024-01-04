extends Area2D
class_name Pickupable

@onready var stay_effect : CPUParticles2D = $Particles2D
@onready var pickup_effect : GPUParticles2D = $Dust

@export var player : Player
@export var display_event : CustomEventChannel
@export_multiline var text_to_display : String

func _ready():
	stay_effect.emitting = true
	connect("body_entered",pickup)

func pickup(_body):
	set_deferred("monitoring",false)
	stay_effect.emitting = false
	pickup_effect.restart()
	player.pick_up_dash_unlock()
	display_event.string_event_sended.emit(text_to_display)
	await get_tree().create_timer(0.5).timeout
	queue_free()
