extends Node
class_name StateMachine

@export var InitialState : State

var current_state : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition.connect(on_child_transition)
	if InitialState : 
		InitialState.on_enter()
		current_state = InitialState

func _process(delta):
	if current_state:
		current_state.on_update(delta)
func  _physics_process(delta):
	if current_state:
		current_state.on_physics_update(delta)
		
func on_child_transition(state : State , new_state_name : String):
	if state != current_state : return
	var new_state : State = states.get(new_state_name.to_lower())
	if !new_state: return
	if state == new_state : return
	if current_state: current_state.on_exit()
	new_state.on_enter()
	current_state = new_state
	
