extends Area2D
class_name Pickupable

@onready var stay_effect : CPUParticles2D = $IdleParticles
@onready var pickup_effect : CPUParticles2D = $PickupParticles

@export var display_event : CustomEventChannel
@export_multiline var text_to_display : String
@export var unlock_type : Unlockable

var data : NodeSaveData

func _ready():
	stay_effect.emitting = true
	connect("body_entered",pickup)
	
	var id = GameManager.get_object_id(self)
	data = NodeSaveData.new()
	data.id = id
	data.status = false
	
	if GameManager.is_object_stored(id):
		queue_free()

func pickup(_body):
	if not _body is Player: return
	var player : Player = _body as Player
	set_deferred("monitoring",false)
	stay_effect.emitting = false
	pickup_effect.restart()
	player.pick_up_upgrade(unlock_type)
	display_event.string_event_sended.emit(text_to_display)
	data.status = true
	GameManager.store_object(data.id,data)
	await get_tree().create_timer(0.5).timeout
	queue_free()
