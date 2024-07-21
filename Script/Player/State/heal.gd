class_name Heal extends State

@onready var effect :GPUParticles2D= $"../../Directions/Effect/HealEffect"
@export var heal_over_time : float = 0.5
@export var cost_over_time : float = 1.5
var active_input : bool

func on_enter()->void:
	super.on_enter()
	active_input = true
	animator.play("heal")
	effect.emitting = true
	
func on_exit()->void:
	super.on_exit()
	active_input = false
	effect.emitting = false
	
func on_update(_delta : float)->void:
	super.on_update(_delta)
	if player.player_data.current_health < player.player_data.max_health:
		if player.player_data.current_mana > 0:
			player.player_data.current_health += heal_over_time * _delta
			player.player_data.current_mana -= cost_over_time * _delta
			player.update_hud_display()
	
func _unhandled_input(event:InputEvent)->void:
	if not is_controllable(): return
	if not active_input: return
	elif event.is_action_released("heal"):
		transition.emit(self,"idle")
