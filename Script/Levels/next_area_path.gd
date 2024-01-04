extends Area2D
class_name NextAreaPath

#@export_dir var map_root_folder: String = "res://Scenes/Level/"
@export_file("*.tscn") var next_scene_file : String

@export var exit_position : Node2D
@export var path_data : PathData

@export var cinematic_camera: CinematicCamera2D
@export var virtual_camera: VirtualCamera2D

func _ready():
	connect("body_entered",_on_player_enter)
	#set player location if pathData are the same
	if SceneManager.is_exit_path(path_data):
		await get_tree().create_timer(0.2).timeout
		cinematic_camera.virtual_camera = virtual_camera
		cinematic_camera.transition_speed = 0
		cinematic_camera.position_smoothing_enabled = false
		cinematic_camera.zoom = virtual_camera.zoom
		SceneManager.set_player_position.emit(exit_position.global_position)
		SceneManager.animation_player.play("dissolve")

func _on_player_enter(body : Node2D):
	if body is Player:
		SceneManager.change_scene_by_name_no_fadeout(next_scene_file,path_data)
