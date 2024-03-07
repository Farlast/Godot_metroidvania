class_name ChargeableAttack
extends State

@onready var attack_box : CollisionShape2D = %AttackArea

@export var charge_time : float = 0.3
@export_group("Audio")
@export var audio_player : AudioPlayer
@export var charge_audio : AudioStream
@export var charge_finish_audio : AudioStreamPlayer2D
@export var attack_audio_player : AudioStreamPlayer2D

var active_input : bool
var charging : bool
var charge_timer : float
var listen_input_window : bool
var attacked : bool

func _ready():
	super._ready()
	animator.animation_finished.connect(on_animation_finish)

func on_enter():
	super.on_enter()
	active_input = true
	charge_timer = 0
	charging = true
	listen_input_window = false
	attacked = false
	animator.play("charge_attack_start")

func on_exit():
	super.on_exit()
	disable_hitbox()
	active_input = false
	charge_timer = 0
	charging = false
	listen_input_window = false

func on_update(_delta : float):
	super.on_update(_delta)
	if charging and charge_timer < charge_time:
		charge_timer += _delta
	if charging and charge_timer >= charge_time:
		charging = false
		if charge_finish_audio : charge_finish_audio.play()

func  _unhandled_input(event):
	if not active_input: return
	if event.is_action_released("attack") and not attacked:
		charging = false
		attacked = true
		if charge_timer < charge_time:
			# normal attack
			transition.emit(self,"attack")
		else:
			# charge version
			animator.play("charge_attack")
			if attack_audio_player : attack_audio_player.play()
###---------------------
func on_animation_finish(_animation_name : String):
	if _animation_name != "charge_attack_start":
		disable_hitbox()
		if not active_input: return
		next_state()

func disable_hitbox():
	attack_box.set_deferred("disabled",true)

func next_state():
	if player.is_on_floor():
		transition.emit(self,"Idle")
	else :
		transition.emit(self,"fall")
