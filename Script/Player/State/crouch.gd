class_name Crouch
extends State

var active_input : bool

func on_enter()->void:
	super.on_enter()
	active_input = true
	animator.play("crouch")
	player.velocity = Vector2.ZERO
	player.front_point.position.y += 40
	
func on_update(_delta : float)->void:
	super.on_update(_delta)
	var direction :float= Input.get_axis("move_down", "move_up")
	if direction >= 0: transition.emit(self,"idle")

func on_physics_update(_delta : float)->void:
	super.on_physics_update(_delta)
	player.add_fall_gravity(_delta)
	player.move_and_slide()
	if not player.is_on_floor():
		transition.emit(self,"fall")

func on_exit()->void:
	super.on_exit()
	active_input = false
	player.velocity = Vector2.ZERO
	player.front_point.position.y -= 40

func _unhandled_input(event:InputEvent)->void:
	if not is_controllable(): return
	if not active_input: return
	if not player.is_on_floor(): return
	if event.is_action_pressed("jump"):
		player.position.y += 1
	elif event.is_action_pressed("attack"):
		transition.emit(self,"crouch_attack")
	elif event.is_action_pressed("dash") and player.is_can_slide:
		transition.emit(self,"slide")
	elif player.skill_system.is_can_use_skill(event):
		player.skill_system.activate_skill()
		#transition.emit(self,"projectile")
