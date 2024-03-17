@tool
extends Area2D
class_name NextAreaPath

@export_category("Camera")
@export var cinematic_camera: CinematicCamera2D
@export var virtual_camera: VirtualCamera2D

@export_category("Passage handle")
@export var exit_position : Node2D
@export_group("This passage","this_")
@export var this_scene_passage_handle : SceneHandle:
	get:
		return this_scene_passage_handle
	set(value):
		this_scene_passage_handle = value
		notify_property_list_changed()
var this_passage_index : int

@export_group("Next passage","next_")
@export var next_scene_passage_handle : SceneHandle:
	get:
		return next_scene_passage_handle
	set(value):
		next_scene_passage_handle = value
		notify_property_list_changed()
var next_passage_target : int 

#region Tools

func _get_property_list():
	var property_usage = PROPERTY_USAGE_DEFAULT
	
	if this_scene_passage_handle == null:
		property_usage = PROPERTY_USAGE_NO_EDITOR
	else:
		property_usage = PROPERTY_USAGE_DEFAULT
	
	var properties = []
	properties.append({
		"name": "this_passage_index",
		"type": TYPE_INT,
		"usage": property_usage,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": array_to_string(this_scene_passage_handle)
	})
	
	if next_scene_passage_handle == null:
		property_usage = PROPERTY_USAGE_NO_EDITOR
	else:
		property_usage = PROPERTY_USAGE_DEFAULT

	properties.append({
		"name": "next_passage_target",
		"type": TYPE_INT,
		"usage": property_usage,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": array_to_string(next_scene_passage_handle)
	})
	return properties

func array_to_string(arr : SceneHandle, separater = ",")->String:
	var string : String = ""
	if arr == null:
		return string
	var handler : Array[PassageHandle] = arr.passage_list
	for item in handler:
		string += str(item.passage_name,separater)
	string = string.left(string.length() - 1)
	return string
#endregion
#region Main

func _ready():
	if not Engine.is_editor_hint():
		connect("body_entered",_on_player_enter)
		var this_passage : PassageHandle
		if next_scene_passage_handle:
			this_passage = this_scene_passage_handle.passage_list[this_passage_index]
		#set player location if pathData are the same
		if SceneManager.is_exit_path(this_passage):
			await get_tree().create_timer(0.2).timeout
			cinematic_camera.virtual_camera = virtual_camera
			cinematic_camera.position_smoothing_enabled = true
			cinematic_camera.zoom = virtual_camera.zoom
			cinematic_camera.global_position = exit_position.global_position
			SceneManager.set_player_position.emit(exit_position.global_position)
			SceneManager.animation_player.play("dissolve")

func _on_player_enter(body : Node2D):
	if body is Player and next_scene_passage_handle != null:
		var passage : PassageHandle = next_scene_passage_handle.passage_list[next_passage_target]
		SceneManager.change_scene_by_name_no_fadeout(passage.target_scene_path,passage)
#endregion
