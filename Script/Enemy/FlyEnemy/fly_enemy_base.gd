class_name FlyEnemy extends Enemy

func on_idle(state : EnemyState,_delta:float)->void:
	super.on_idle(state,_delta)
	state.transition.emit(state,"flyto")

func take_damage(damage_data : DamageData)->bool:
	var result :bool= super.take_damage(damage_data)
	if health_system.health.current_value > 0:
		state_machine.current_state.transition.emit(state_machine.current_state,"stagger")
	return result

func dead()->void:
	state_machine.current_state.transition.emit(state_machine.current_state,"empty")
	super.dead()
