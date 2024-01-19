extends Area2D
class_name Pickupable

@onready var stay_effect : CPUParticles2D = $IdleParticles
@onready var pickup_effect : CPUParticles2D = $PickupParticles

@export var display_event : CustomEventChannel
@export_multiline var text_to_display : String
@export var unlock_type : Unlockable

func _ready():
	stay_effect.emitting = true
	connect("body_entered",pickup)

func pickup(_body):
	if not _body is Player: return
	var player : Player = _body as Player
	set_deferred("monitoring",false)
	stay_effect.emitting = false
	pickup_effect.restart()
	player.pick_up_upgrade(unlock_type)
	display_event.string_event_sended.emit(text_to_display)
	await get_tree().create_timer(0.5).timeout
	queue_free()
