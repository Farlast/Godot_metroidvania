class_name SaveSystem
extends RefCounted

const  SavePath_prod :String = "res://saveData.tres"
const  SavePath :String = "user://saveData.tres"
const  SettingSavePath :String = "user://settingData.tres"

var registered_objects: Dictionary #[String, bool]
var stored_objects: Dictionary #[String, bool]

func save_game():
	var save_game_file : SaveData = SaveData.new()
	save_game_file.player_data = PlayerData.new()
	save_game_file.player_data.replace_data(GameManager.player_data)
	save_game_file.player_data.position = GameManager.player_data.position
	save_game_file.player_data.is_dash_unlock = GameManager.player_data.is_dash_unlock
	save_game_file.player_data.is_doublejump_unlock =  GameManager.player_data.is_doublejump_unlock
	save_game_file.player_data.last_scene_visit_path = SceneManager.last_savepoint_visit.target_scene_path
	
	ResourceSaver.save(save_game_file,SavePath)

func load_game():
	var save_game_file : SaveData = load(SavePath) as SaveData
	GameManager.player_data.replace_data(save_game_file.player_data)
	GameManager.player_data.position = save_game_file.player_data.position
	GameManager.player_data.is_dash_unlock = save_game_file.player_data.is_dash_unlock
	GameManager.player_data.last_scene_visit_path = save_game_file.player_data.last_scene_visit_path
	GameManager.player_data.is_doublejump_unlock = save_game_file.player_data.is_doublejump_unlock
	
	SceneManager.last_savepoint_visit = PassageHandle.new()
	SceneManager.last_savepoint_visit.target_scene_path = save_game_file.player_data.last_scene_visit_path

func save_setting(setting : SettingData):
	ResourceSaver.save(setting,SettingSavePath)

func load_setting() -> SettingData:
	if ResourceLoader.exists(SettingSavePath):
		return load(SettingSavePath) as SettingData
	else :
		return SettingData.new()

func get_object_id(object: Object) -> String:
	if object.has_meta(&"object_id"):
		return object.get_meta(&"object_id")
	elif object.has_method(&"_get_object_id"):
		var id: String = object._get_object_id()
		object.set_meta(&"object_id", id)
		return id
	elif object is Node:
		var id := str(object.owner.scene_file_path.get_file().get_basename(), "/", object.get_parent().name if object.get_parent() != object.owner else ".", "/", object.name)
		object.set_meta(&"object_id", id)
		return id
	return ""

func register_storable_object(object: Object) -> bool:
	var id: String = get_object_id(object)
	if not id in registered_objects:
		registered_objects[id] = true
		return true
	return false

func store_object(object: Object):
	var id: String = get_object_id(object)
	assert(id in registered_objects)
	assert(not id in stored_objects)
	registered_objects.erase(id)
	stored_objects[id] = true

func is_object_stored(object: Object) -> bool:
	var id: String = get_object_id(object)
	return id in stored_objects
