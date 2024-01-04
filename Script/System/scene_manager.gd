extends CanvasLayer

##############
# SceneManager
# Autoload
##############

signal scene_load_finished
signal set_player_position(position : Vector2)

signal respawn_same_level(loacation_data : PathData)
signal respawn_at_position(position : Vector2)

var animation_player : AnimationPlayer
var path_data : PathData
var current_scene : String

#region Respawn System

var need_respawn : bool = false
var last_savepoint_visit : PathData
var savepoint_scene : String
#reset on player dead
func respawn_last_savepoint():
	#if in current scene reset position
	path_data = last_savepoint_visit
	if savepoint_scene == current_scene:
		animation_player.play_backwards("dissolve")
		await  animation_player.animation_finished
		get_tree().reload_current_scene()
		animation_player.play("dissolve")
		#respawn_same_level.emit(last_savepoint_visit)
		need_respawn = true
	else:
		change_scene_by_name_no_fadeout(savepoint_scene,last_savepoint_visit)
		need_respawn = true
#endregion
func _ready():
	animation_player = $AnimationPlayer

func change_scene_by_name(scene : String):
	animation_player.play_backwards("dissolve")
	await  animation_player.animation_finished
	get_tree().change_scene_to_file(scene)
	animation_player.play("dissolve")
	await  animation_player.animation_finished
	current_scene = scene
	scene_load_finished.emit()

func change_scene_by_name_no_fadeout(scene : String, entered_path :PathData):
	animation_player.play_backwards("dissolve")
	await  animation_player.animation_finished
	get_tree().change_scene_to_file(scene)
	path_data = entered_path
	current_scene = scene
	scene_load_finished.emit()

func is_exit_path(exit_path :PathData):
	return path_data == exit_path
	
func callback_test(callback := Callable()):
	callback.call()
