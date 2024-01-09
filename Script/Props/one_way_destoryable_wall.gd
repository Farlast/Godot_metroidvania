extends StaticBody2D

@onready var hurt_box : CollisionShape2D = $HurtBox/CollisionShape2D
@onready var collition : CollisionShape2D = $CollisionShape2D

var destory_effect : GPUParticles2D
@onready var hit_effect : CPUParticles2D = $Effect/hit_effect
@onready var slash_effect : CPUParticles2D = $Effect/slash_effect
var block_effect : CPUParticles2D

@export_group("Audio","audio_")
@export var audio_destory : AudioStream
@export var audio_hit : AudioStream
@export var audio_block : AudioStream
@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer

@export_group("Default value")
@export var max_hp : float = 1
@export var free_dalay : float = 1
@export_enum("Left","Right") var faceing_side : int

var hp : float = 1

func _ready():
	hp = max_hp
	if faceing_side == 0:
		scale = abs(scale)
	else :
		scale = -abs(scale)


func take_damage(damage_data : DamageData):
	
	if faceing_side == 0: #left
		if damage_data.sender_position.x > global_position.x: # from the right
			hited(damage_data)
		else:
			blocked()
	else:
		if damage_data.sender_position.x > global_position.x: # from the right
			blocked()
		else:
			hited(damage_data)
			
	if hp<= 0:
		dead()
		
func blocked():
	audio_player.stream = audio_block
	audio_player.play()
	
func hited(damage_data):
	hit_effect.restart()
	slash_effect.restart()
	hp -= damage_data.damage
	audio_player.stream = audio_hit
	audio_player.play()
	pass
	
func dead():
	audio_player.stream = audio_destory
	audio_player.play()
	
	$Sprite2D.visible = false
	set_deferred("hurt_box.disabled",false)
	set_deferred("collition.disabled",false)
	
	await get_tree().create_timer(free_dalay).timeout
	queue_free()
