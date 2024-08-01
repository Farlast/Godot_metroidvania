class_name Chargeable
extends State

@export var animation_name : String = "charge_attack_start"
@export var input_action_name : String = "attack"
@export var charge_time : float = 0.3
@export var auto_release : bool
@export_group("State transition")
@export var next_normal_sate : State 
@export var next_chrage_sate : State 
@export_group("Audio")
@export var charge_finish_audio : AudioStreamPlayer2D
@export var attack_audio_player : AudioStreamPlayer2D
@export_group("Move distance")
@export var velocity_move : Vector2 = Vector2.ZERO

var attack_box_col : CollisionShape2D
var active_input : bool
var charging : bool
var charge_timer : float
var listen_input_window : bool
var attacked : bool
var skill : PackedScene

func _ready()->void:
	super._ready()
	animator.animation_finished.connect(on_animation_finish)

func on_enter()->void:
	super.on_enter()
	active_input = true
	charge_timer = 0
	charging = true
	listen_input_window = false
	attacked = false
	animator.play(animation_name)
	player.velocity = Vector2.ZERO

func on_exit()->void:
	super.on_exit()
	active_input = false
	charge_timer = 0
	charging = false
	listen_input_window = false

func on_update(_delta : float)->void:
	super.on_update(_delta)
	if charging and charge_timer < charge_time:
		charge_timer += _delta
	if charging and charge_timer >= charge_time:
		charging = false
		if charge_finish_audio : charge_finish_audio.play()
		if auto_release:
			transition.emit(self,next_chrage_sate.name.to_lower())

func on_physics_update(_delta : float)->void:
	super.on_physics_update(_delta)
	player.add_drag(_delta,false,5)
	player.move_and_slide()

func  _unhandled_input(event:InputEvent)->void:
	if not is_controllable(): return
	if not active_input: return
	if event.is_action_released(input_action_name) and not attacked:
		charging = false
		attacked = true
		if charge_timer < charge_time:
			# normal attack
			transition.emit(self,next_normal_sate.name.to_lower())
		else:
			# charge version
			transition.emit(self,next_chrage_sate.name.to_lower())

func on_animation_finish(_animation_name : String)->void:
	if _animation_name != "charge_attack_start" and active_input:
		next_state()

func next_state()->void:
	if player.is_on_floor():
		transition.emit(self,"Idle")
	else :
		transition.emit(self,"fall")
