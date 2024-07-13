extends State
class_name Knockback

var get_hit_direction : Vector2
var is_unfreeze : bool
var temp_damage_data : DamageData

func on_enter():
	super.on_enter()
	animator.play("hit")
	player.velocity = Vector2.ZERO
	is_unfreeze = true
	GameManager.time_manager.freeze_time_duration()
	await get_tree().create_timer(0.5).timeout
	player.is_iframe_active = true
	player.iframe_timer = 0
	if temp_damage_data.take_damage_rule == temp_damage_data.TakeDamageRule.RESET:
		player.reset_position()
	else:
		is_unfreeze = false
		get_hit_direction = (temp_damage_data.sender_position - player.global_position).normalized()
		if get_hit_direction.y > 0 : get_hit_direction.y = 1
		else: get_hit_direction.y = -1
		if get_hit_direction.x > 0 : get_hit_direction.x = 1
		else: get_hit_direction.x = -1
		
		if player.is_on_floor():
			player.velocity.x = player.knockback_force * -get_hit_direction.x
			player.velocity.y = -(player.knockback_force * get_hit_direction.y)
		else:
			player.velocity.x = player.knockback_force * 2 * -get_hit_direction.x
			player.velocity.y = -(player.knockback_force * get_hit_direction.y * 2)
	
	await get_tree().create_timer(0.3).timeout
	if player.is_on_floor():
		transition.emit(self,"idle")
	else:
		transition.emit(self,"fall")
	

func on_exit():
	super.on_exit()
	player.velocity = Vector2.ZERO
	player.get_hit_direction = Vector2.ZERO

func on_physics_update(_delta : float):
	if is_unfreeze: return
	player.add_fall_gravity(_delta)
	player.move_and_slide()


func _on_player_take_damage_trigger(damage_data):
	temp_damage_data = damage_data
