class_name BulletJump extends State

@export var shooting_time : float = 0.3
var off_ground : bool
var active_input : bool

func on_enter():
	super.on_enter()
	player.velocity.y = player.jump_velocity
	player.velocity.x += 200 * player.direction_holder.scale.x
	off_ground = false
	animator.play("wall_jump")
	active_input = true
	if player.is_on_floor():
		player.set_last_ground_position()
	await get_tree().create_timer(shooting_time).timeout
	transition.emit(self,"fall")

func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
	if not player.is_on_floor():
		off_ground = true
		player.add_fall_gravity(_delta)
	elif player.is_on_floor() && off_ground:
		transition.emit(self,"Idle")
		
	if player.velocity.y > 0:
		transition.emit(self,"fall")
		return

	player.move_and_slide()
