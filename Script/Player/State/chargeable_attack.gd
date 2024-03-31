class_name ChargeableAttack
extends State

@export var charge_time : float = 0.3
@export_group("State transition")
@export var animation_name : String = "charge_attack"
@export var next_attack_sate : State 
@export_group("Damage")
@export var attack_box : AttackBox
@export var damage_multiply : float
@export_group("Audio")
@export var audio_player : AudioPlayer
@export var charge_audio : AudioStream
@export var charge_finish_audio : AudioStreamPlayer2D
@export var attack_audio_player : AudioStreamPlayer2D
@export_group("Move distance")
@export var velocity_move : Vector2 = Vector2(200,0)

var attack_box_col : CollisionShape2D
var active_input : bool
var charging : bool
var charge_timer : float
var listen_input_window : bool
var attacked : bool
var skill : PackedScene

func _ready():
	super._ready()
	attack_box_col = attack_box.get_child(0)
	animator.animation_finished.connect(on_animation_finish)

func on_enter():
	super.on_enter()
	active_input = true
	charge_timer = 0
	charging = true
	listen_input_window = false
	attacked = false
	animator.play("charge_attack_start")
	player.velocity = Vector2.ZERO
	attack_box.damage_data.damage_multiply = damage_multiply

func on_exit():
	super.on_exit()
	disable_hitbox()
	active_input = false
	charge_timer = 0
	charging = false
	listen_input_window = false
	player.dash_iframe = false

func on_update(_delta : float):
	super.on_update(_delta)
	if charging and charge_timer < charge_time:
		charge_timer += _delta
	if charging and charge_timer >= charge_time:
		charging = false
		if charge_finish_audio : charge_finish_audio.play()

func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
	player.add_drag(_delta,false,5)
	player.move_and_slide()

func  _unhandled_input(event):
	if not active_input: return
	if event.is_action_released("attack") and not attacked:
		charging = false
		attacked = true
		if charge_timer < charge_time:
			# normal attack
			transition.emit(self,next_attack_sate.name.to_lower())
		else:
			# charge version
			player.skill_system.chrage_skill_active()
			animator.play("charge_attack")
			if attack_audio_player : attack_audio_player.play()
			player.dash_iframe = true
			player.velocity = Vector2(player.direction_holder.scale.x * velocity_move.x,velocity_move.y)
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
