extends Area2D
class_name Bullet

@onready var attack_box_col : CollisionShape2D = $AttackBox/CollisionShape2D
@onready var attack_box : AttackBox = $AttackBox
@onready var audio_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var piercing : bool = false
@export var time_to_free : float = 1
@export var life_time : float = 0.3

var start_audio : AudioStream
var runing_audio : AudioStream
var end_audio : AudioStream

var damage_data : DamageData
var direction : Vector2
var speed : float = 800
var stop : bool

func _ready()->void:
	stop = false
	attack_box.damage_data = damage_data
	body_entered.connect(grounded)
	audio_player_2d.stream = start_audio
	audio_player_2d.play()
	await get_tree().create_timer(life_time).timeout
	on_free()

func setup(_direction : Vector2,_damage_data : DamageData)->void:
	direction = _direction
	attack_box.damage_data = _damage_data

func set_audios(start:AudioStream,running:AudioStream,end:AudioStream)->void:
	start_audio = start
	runing_audio = running
	end_audio = end

func take_damage(_damage:DamageData)->bool:
	audio_player_2d.stream = runing_audio
	audio_player_2d.play()
	on_free()
	return true

func attack_feedback(_report:AttackReport)->void:
	if not piercing:
		on_free()

func grounded(_body:Node2D)->void:
	on_free()

func _physics_process(delta:float)->void:
	if not stop:
		global_position += direction.normalized() * (speed * delta)
	
func on_free()->void:
	if stop: return
	stop = true
	attack_box_col.set_deferred("disabled",true)
	$AnimationPlayer.play("destory")
	audio_player_2d.stream = runing_audio
	audio_player_2d.play()
	await get_tree().create_timer(time_to_free).timeout
	queue_free()
