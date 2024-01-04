extends Destroyable

@onready var col : StaticBody2D = $StaticBody2D 
@onready var destory_sound := $DestroySound

func clear_on_dead():
	destory_sound.play()
	if col:
		col.collision_layer = 0

func play_effect_on_hit():
	super.play_effect_on_hit()
	destory_sound.play()
