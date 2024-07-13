extends GrabbableHost

func take_damage(_damage_data:DamageData):
	if not havested:
		animator.play("explode")
		havested = true
		get_tree().create_timer(refill_time).timeout.connect(refill)

