extends Area2D

@export_file("*.tscn") var next_scene_file : String

func _ready():
	connect("body_entered",_on_player_enter)

func _on_player_enter(body : Node2D):
	if body is Player:
		SceneManager.change_scene_by_name(next_scene_file)
