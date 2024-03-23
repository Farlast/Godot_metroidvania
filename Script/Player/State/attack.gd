class_name Attack
extends State

### attack that cannot combo
### exp up_attack
@export_group("Attack box")
@export var attack_box : AttackBox
@export_group("Audio")
@export var attack_audio : AudioStreamPlayer2D
@export_group("State transition")
@export var animation_name : String = "attack"
@export_group("Move distance")
@export var freely_move : bool
@export var velocity_move : Vector2 = Vector2(200,0)

var active_input : bool
var listen_input_window : bool 
var attack_box_col : CollisionShape2D
var attack_system : AttackSystem

func _ready():
	super._ready()
	animator.animation_finished.connect(on_animation_finish)
	player.attack_success.connect(on_attack_success)
	attack_box_col = attack_box.get_child(0)
	attack_system = player.attack_system

func on_enter():
	super.on_enter()
	active_input = true
	listen_input_window = false
	animator.play(animation_name)
	attack_system.enable_hitbox.connect(enable_hitbox)
	attack_system.disable_hitbox.connect(disable_hitbox)
	if not freely_move:
		player.velocity = Vector2(player.direction_holder.scale.x * velocity_move.x,velocity_move.y)
	if attack_audio:
		attack_audio.play()

### call by animation
func enable_hitbox():
	attack_box_col.set_deferred("disabled",false)
	
func disable_hitbox():
	attack_box_col.set_deferred("disabled",true)

func next_state():
	if player.is_on_floor() : 
		transition.emit(self,"Idle")
	else :
		transition.emit(self,"fall")

func on_animation_finish(_animation_name : String):
	disable_hitbox()
	if not active_input: return
	next_state()

func allow_next_animation():
	listen_input_window = true

func on_attack_success():
	if not active_input: return
	if player.get_hit_direction != Vector2.ZERO:
		player.velocity.x = player.knockback_force/2 * -player.get_hit_direction.x

func on_exit():
	super.on_exit()
	disable_hitbox()
	active_input = false
	player.get_hit_direction = Vector2.ZERO
	attack_system.enable_hitbox.disconnect(enable_hitbox)
	attack_system.disable_hitbox.disconnect(disable_hitbox)
	
func on_update(_delta : float):
	super.on_update(_delta)

func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
	player.add_drag(_delta)
	player.add_fall_gravity(_delta)
	player.move_and_slide()
	
func  _unhandled_input(event):
	if not active_input: return
	
	if event.is_action_released("move_left") || event.is_action_released("move_right"):
		player.velocity.x = 0
	elif not player.is_on_floor() and event.is_action_released("jump"):
		## stop going up on air
		if player.velocity.y < 0:
			player.velocity.y += abs(player.velocity.y)
	elif event.is_action_pressed("dash") && player.is_can_dash():
		transition.emit(self,"dash")
