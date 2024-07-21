extends State
##-------------------------------##
## cast projectile while moving
##-------------------------------##

@export var charge_time : float = 0.25
@export var cooldown: float = 0.3

@export var animation_name : String = "sample"
@export var next_normal_sate : State 
@export var next_chrage_sate : State

var active_input : bool

func on_enter()->void:
	animator.animation_finished.connect(on_animation_finish)
	super.on_enter()
	active_input = true
	animator.play(animation_name)
	var h_direction :float = Input.get_axis("move_left", "move_right",)
	var v_direction :float = Input.get_axis("move_up", "move_down")
	if player.is_on_floor():
		player.skill_system.fire_projectile(Vector2(h_direction,v_direction))
	else:
		player.skill_system.midair_fire_projectile(Vector2(h_direction,v_direction))

func on_exit()->void:
	animator.animation_finished.disconnect(on_animation_finish)
	super.on_exit()
	active_input = false

func on_physics_update(_delta : float)->void:
	super.on_physics_update(_delta)
	player.move_horizontal(player.walk_speed)
	player.add_fall_gravity(_delta)
	player.move_and_slide()

func on_animation_finish(_animation_name : String)->void:
	if _animation_name != animation_name : return
	if not active_input: return
	if player.is_on_floor():
		transition.emit(self,"idle")
	else:
		transition.emit(self,"fall")
