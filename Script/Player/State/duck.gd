extends State
class_name Duck

var get_hit_direction : Vector2
var is_unfreeze : bool
var active_input : bool

func on_enter():
	super.on_enter()
	active_input = true
	animator.play("duck")
	player.velocity = Vector2.ZERO
	
func on_update(_delta : float):
	super.on_update(_delta)
	var direction = Input.get_axis("move_down", "move_up")
	if direction >= 0: transition.emit(self,"idle")

func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
	player.add_fall_gravity(_delta)
	player.move_and_slide()
	if not player.is_on_floor():
		transition.emit(self,"fall")

func on_exit():
	super.on_exit()
	active_input = false
	player.velocity = Vector2.ZERO
	player.get_hit_direction = Vector2.ZERO

func _unhandled_input(event):
	if not active_input: return
	if not player.is_on_floor(): return
	if event.is_action_pressed("jump"):
		player.position.y += 1
