extends EnemyState
class_name StanceBreak

@export var stunt_time: float = 1
var active_input : bool

func on_enter():
	super.on_enter()
	active_input = true
	agent.velocity = Vector2.ZERO
	animator.play("stagger")
	agent.state_machine.current_state.transition.emit(self,"empty")
	await get_tree().create_timer(stunt_time).timeout
	agent.health_system.stance.add(agent.health_system.stance.max_value)
	agent.stagger_bar.update_hp(agent.health_system.stance.current_value,
	agent.health_system.stance.max_value)
	if not active_input: return
	agent.state_machine.current_state.transition.emit(self,"idle")

func on_exit():
	super.on_exit()
	active_input = false
