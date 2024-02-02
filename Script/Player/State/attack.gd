extends State
class_name Attack

@export var attack_audio : AudioStreamPlayer2D

var active_input : bool
var attack_buffer : bool
var lock_movement : bool
var old_direction : float
var direction : float
var combo : int = 0

func on_enter():
	super.on_enter()
	active_input = true
	lock_movement = false
	start_attack()

func start_attack():
	if combo % 2 == 0:
		animator.play("attack")
	else:
		animator.play("attack_1")
	combo += 1
	
	if not lock_movement:
		player.update_area()
		direction = Input.get_axis("move_left", "move_right")
		if direction != 0:
			old_direction = direction
		player.velocity.x = direction * player.walk_speed
	
	if attack_audio:
		attack_audio.play()
	await animator.animation_finished
	
	if attack_buffer and combo < 3:
		attack_buffer = false
		lock_movement = true
		player.velocity = Vector2(player.direction_holder.scale.x * 120,0)
		start_attack()
		return
	
	if player.is_on_floor() : 
		transition.emit(self,"Idle")
	else :
		transition.emit(self,"fall")

func on_exit():
	super.on_exit()
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
		player.velocity = Vector2.ZERO
		lock_movement = true
	if event.is_action_pressed("attack"):
		attack_buffer = true

func reset_buffer():
	attack_buffer = false
