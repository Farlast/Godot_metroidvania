class_name AttackCombo
extends State

@export_group("State transition")
@export var animation_name : String = "attack"
@export var next_attack_sate : State
@export_group("Damage")
@export var attack_box : AttackBox
@export var damage_multiply : float
@export_group("Audio")
@export var attack_audio : AudioStreamPlayer2D
@export_group("Move distance")
@export var velocity_move : Vector2 = Vector2(200,0)

var attack_box_col : CollisionShape2D
var active_input : bool
var attack_buffer : bool  = false
var listen_input_window : bool
var direction : float

func _ready():
	super._ready()
	animator.animation_finished.connect(on_animation_finish)
	player.attack_success.connect(on_attack_success)
	attack_box_col = attack_box.get_child(0)

############
## Custom
############
func on_enter():
	attack_box.get_damage_data().damage_multiply = damage_multiply
	player.velocity = Vector2(player.direction_holder.scale.x * velocity_move.x,velocity_move.y)
	super.on_enter()
	active_input = true
	listen_input_window = false
	play_animation()
	attack_audio.play()

func on_attack_success():
	if not active_input: return	
	if player.get_hit_direction != Vector2.ZERO:
		player.velocity.x = velocity_move.x/2 * -player.get_hit_direction.x

func on_animation_finish(_animation_name : String):
	disable_hitbox()
	if not active_input: return
	end_state()

func end_state():
	if player.is_on_floor() : 
		transition.emit(self,"Idle")
	else :
		transition.emit(self,"fall")

func on_exit():
	super.on_exit()
	disable_hitbox()
	active_input = false
	attack_buffer = false
	player.get_hit_direction = Vector2.ZERO

func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
	player.add_fall_gravity(_delta)
	player.add_drag(_delta)
	player.move_and_slide()

func  _unhandled_input(event):
	if not active_input: return
	if event.is_action_pressed("dash") && player.is_can_dash():
		transition.emit(self,"dash")
	elif event.is_action_pressed("jump") && player.is_on_floor():
		transition.emit(self,"Jump")
	elif event.is_action_pressed("attack"):
		attack_buffer = true
		if listen_input_window:
			allow_next_animation()
	elif listen_input_window and not player.is_on_floor() and event.is_action_pressed("move_left") || event.is_action_pressed("move_right"):
		transition.emit(self,"run")

### call by animation
func enable_hitbox():
	attack_box_col.set_deferred("disabled",false)

func disable_hitbox():
	attack_box_col.set_deferred("disabled",true)

func allow_next_animation():
	### allow exit state before animation finish
	listen_input_window = true
	if not active_input: return
	if attack_buffer:
		listen_input_window = false
		next_combo_state()

func play_animation():
	animator.play(animation_name)

func next_combo_state():
	if next_attack_sate:
		transition.emit(self,next_attack_sate.name.to_lower())
