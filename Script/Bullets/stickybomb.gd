extends Bullet

func _physics_process(delta):
	if not stop:
		global_position += direction * (speed * delta)

func on_free():
	stop = true
	$AnimationPlayer.play("detonate")

func on_grounded(_body : Node2D):
	on_free()

func attack_feedback(_report : AttackReport):
	on_free()

func _on_animation_player_animation_finished(anim_name:String):
	if anim_name.match("detonate"):
		await get_tree().create_timer(time_to_free).timeout
		queue_free()

func _on_area_entered(_area):
	on_free()
