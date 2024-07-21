extends Area2D
class_name SavePoint

@export var spawn_position : Node2D
@export var path_data : PassageHandle

@export var cinematic_camera: CinematicCamera2D
@export var virtual_camera: VirtualCamera2D

@export var player : Player

@onready var effect: GPUParticles2D = $Dust

func _ready()->void:
	SceneManager.respawn_same_level.connect(respawn_player)
	connect("body_entered",on_save)
	if SceneManager.need_respawn && SceneManager.last_savepoint_visit == path_data:
		respawn_player(SceneManager.last_savepoint_visit)
	
func on_save(_body:Node2D)->void:
	effect.restart()
	SceneManager.last_savepoint_visit = path_data
	SceneManager.savepoint_scene = path_data.target_scene_path
	GameManager.player_data.position = spawn_position.global_position
	var saveSys :SaveSystem = GameManager.save_system as SaveSystem
	saveSys.save_game()
	
	player.refill_health()

func respawn_player(loacation_data : PassageHandle)->void:
	if loacation_data == path_data:
		cinematic_camera.virtual_camera = virtual_camera
		cinematic_camera.transition_speed = 0
		cinematic_camera.position_smoothing_enabled = false
		player.respawn_after_dead(spawn_position.global_position)
		SceneManager.animation_player.play("dissolve")
		SceneManager.need_respawn = false
	
