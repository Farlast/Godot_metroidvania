extends Node2D

@onready var music : AudioStreamPlayer = $Music

func _on_area_2d_body_entered(_body):
	if not music.playing:
		music.play()

