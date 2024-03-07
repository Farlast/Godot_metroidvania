extends State
class_name AttackCombo

@onready var attack_box : CollisionShape2D = %AttackArea
@onready var attack_box_down : CollisionShape2D = %DownAttackArea
@onready var attack_box_up : CollisionShape2D = %UpAttackArea

@export var attack_audio : AudioStreamPlayer2D

enum AttackMode{
	BASIC,
	AIR,
	DOWN,
	UP
}
var active_input : bool
var attack_buffer : bool  = false
var listen_input_window : bool 
var lock_movement : bool
var attack_mode : AttackMode
var direction : float
var combo : int = 0

func _ready():
	super._ready()
	animator.animation_finished.connect(on_animation_finish)
	player.attack_success.connect(on_attack_success)

func on_enter():
	super.on_enter()
	active_input = true
	lock_movement = true
	listen_input_window = false
	
	var v_direction = Input.get_axis("move_down", "move_up")
	
	if player.is_on_floor():
		attack_mode = AttackMode.BASIC
		start_attack()
	elif v_direction < 0:
		attack_mode = AttackMode.DOWN
		down_attack()
	elif v_direction == 0:
		attack_mode = AttackMode.AIR
		air_attack()
	elif v_direction > 0:
		attack_mode = AttackMode.UP
		up_attack()

func start_attack():
	
	match combo:
		0: 
			animator.play("attack")
		1: 
			animator.play("attack_1")
		2:
			animator.play("attack")
	combo += 1
	
	if not lock_movement:
		attack_movement()
	else:
		player.velocity = Vector2(player.direction_holder.scale.x * 120,0)
		
	if attack_audio:
		attack_audio.play()

func air_attack():
	animator.play("air_attack")
	attack_movement()
	if attack_audio:
		attack_audio.play()

func down_attack():
	animator.play("attack_down")
	attack_movement()
	if attack_audio:
		attack_audio.play()
	
func up_attack():
	animator.play("attack_up")
	attack_movement()
	if attack_audio:
		attack_audio.play()

func attack_movement():
	player.update_area()
	direction = ceil(Input.get_axis("move_left", "move_right"))
	player.velocity.x = direction * player.walk_speed

### call by animation
func enable_hitbox():
	match attack_mode:
		AttackMode.BASIC:
			attack_box.set_deferred("disabled",false)
		AttackMode.DOWN:
			attack_box_down.set_deferred("disabled",false)
		AttackMode.AIR:
			attack_box.set_deferred("disabled",false)
		AttackMode.UP:
			attack_box_up.set_deferred("disabled",false)

func disable_hitbox():
	attack_box.set_deferred("disabled",true)
	attack_box_down.set_deferred("disabled",true)
	attack_box_up.set_deferred("disabled",true)

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
	if not active_input: return
	if attack_mode == AttackMode.BASIC and attack_buffer and combo < 3:
		attack_buffer = false
		lock_movement = true
		player.velocity = Vector2(player.direction_holder.scale.x * 120,0)
		listen_input_window = false
		start_attack()

func on_attack_success():
	if not active_input: return
	if attack_mode == AttackMode.DOWN:
		player.velocity.y = -800
	else:
		if player.get_hit_direction != Vector2.ZERO:
			player.velocity.x = player.knockback_force/2 * -player.get_hit_direction.x

func on_exit():
	super.on_exit()
	disable_hitbox()
	active_input = false
	player.get_hit_direction = Vector2.ZERO
	player.attack_cooldown()
	reset_buffer()
	combo = 0	
	lock_movement = false
	
func on_update(_delta : float):
	super.on_update(_delta)

func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
	player.add_fall_gravity(_delta)
	player.move_and_slide()
	
func  _unhandled_input(event):
	if not active_input: return
	
	if event.is_action_released("move_left") || event.is_action_released("move_right"):
		player.velocity.x = 0
		lock_movement = true
	elif not player.is_on_floor() and event.is_action_released("jump"):
		if player.velocity.y < 0:
			player.velocity.y += abs(player.velocity.y)
	elif event.is_action_pressed("dash") && player.is_can_dash():
		transition.emit(self,"dash")
	elif event.is_action_pressed("jump") && player.is_on_floor():
		transition.emit(self,"Jump")
	elif event.is_action_pressed("attack"):
		attack_buffer = true
		if listen_input_window:
			allow_next_animation()

func reset_buffer():
	attack_buffer = false
