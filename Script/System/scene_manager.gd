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
var entered_passage : PassageHandle
var current_scene : String

#region Respawn System

var need_respawn : bool = false
var last_savepoint_visit : PassageHandle
var savepoint_scene : String
#reset on player dead
func respawn_last_savepoint():
	#if in current scene reset position
	entered_passage = last_savepoint_visit
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

func change_scene_by_name_no_fadeout(scene : String, entered_path :PassageHandle):
	animation_player.play_backwards("dissolve")
	await  animation_player.animation_finished
	get_tree().change_scene_to_file(scene)
	entered_passage = entered_path
	current_scene = scene
	scene_load_finished.emit()

func is_exit_path(_passage : PassageHandle):
	if entered_passage == null: return false
	return entered_passage.target_passage_id == _passage.target_passage_id
