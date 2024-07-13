class_name FlyEnemy extends Enemy

func on_idle(state : EnemyState,_delta:float):
	super.on_idle(state,_delta)
	if health_system.stance.current_value > 0:
		state.transition.emit(state,"flyto")

func on_stance_break():
	if not health_system.is_dead():
		state_machine.current_state.transition.emit(state_machine.current_state,"stancebreak")

func take_damage(damage_data : DamageData)->bool:
	var result = super.take_damage(damage_data)
	if health_system.health.current_value > 0 and health_system.stance.current_value > 0:
		state_machine.current_state.transition.emit(state_machine.current_state,"stagger")
	return result

func dead():
	state_machine.current_state.transition.emit(state_machine.current_state,"empty")
	super.dead()
