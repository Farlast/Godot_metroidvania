extends EnemyState
class_name StanceBreak

@export var stunt_time: float = 1
var timer : float
var active_input : bool

func on_enter():
	super.on_enter()
	active_input = true
	timer = 0
	agent.velocity = Vector2.ZERO
	animator.play("stagger")

func on_exit():
	super.on_exit()
	active_input = false
	timer = 0

func on_update(_delta : float):
	super.on_update(_delta)
	timer += _delta
	if timer > stunt_time:
		next_state()

func next_state():
	agent.health_system.stance.add(agent.health_system.stance.max_value)
	agent.stagger_bar.update_hp(agent.health_system.stance.current_value,
	agent.health_system.stance.max_value)
	if not active_input: return
	agent.state_machine.current_state.transition.emit(self,"idle")
