class_name SaveSystem
extends RefCounted

#const  SavePath :String = "res://saveData.tres"
#const  SavePath1 :String = "res://saveData_1.tres"
#const  SavePath2 :String = "res://saveData_2.tres"
#const  SavePath3 :String = "res://saveData_3.tres"
#const  SavePath4 :String = "res://saveData_4.tres"

###prod
const  SavePath1 :String = "user://saveData_1.tres"
const  SavePath2 :String = "user://saveData_2.tres"
const  SavePath3 :String = "user://saveData_3.tres"
const  SavePath4 :String = "user://saveData_4.tres"
const  SettingSavePath :String = "user://settingData.tres"

var stored_objects: Dictionary #[String, NodeSaveData]
var current_save_index : int = 1

func save_game():
	var save_path : String = get_save_path_by_index(current_save_index)
	var save_game_file : SaveData = SaveData.new()
	save_game_file.player_data = PlayerData.new()
	save_game_file.player_data.replace_data(GameManager.player_data)
	save_game_file.player_data.position = GameManager.player_data.position
	save_game_file.player_data.is_dash_unlock = GameManager.player_data.is_dash_unlock
	save_game_file.player_data.is_doublejump_unlock =  GameManager.player_data.is_doublejump_unlock
	save_game_file.player_data.last_scene_visit_path = SceneManager.last_savepoint_visit.target_scene_path
	
	### save stored object
	save_game_file.save_dict = stored_objects
	
	ResourceSaver.save(save_game_file,save_path)

func load_game(save_index:int):
	current_save_index = save_index
	var save_path :String = get_save_path_by_index(save_index)
	var save_game_file : SaveData = load(save_path) as SaveData
	
	GameManager.player_data.replace_data(save_game_file.player_data)
	SceneManager.last_savepoint_visit = PassageHandle.new()
	SceneManager.last_savepoint_visit.target_scene_path = save_game_file.player_data.last_scene_visit_path
	
	### load save object
	stored_objects = save_game_file.save_dict

func get_save_data(save_index:int) -> SaveData:
	var save_path :String = get_save_path_by_index(save_index)
	if ResourceLoader.exists(save_path):
		return load(save_path) as SaveData
	else:
		return null
	
func delete_save(save_index:int):
	var save_path :String = get_save_path_by_index(save_index)
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(save_path)

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
		var id := str(object.owner.scene_file_path.get_file().get_basename(), "/",
		 object.get_parent().name if object.get_parent() != object.owner else ".",
		 "/", object.name)
		object.set_meta(&"object_id", id)
		return id
	return ""
func get_save_path_by_index(save_index : int)-> String:
	var save_path : String = ""
	match save_index:
		1:
			save_path = SavePath1
		2:
			save_path = SavePath2
		3:
			save_path = SavePath3
		4:
			save_path = SavePath4
		_:
			save_path = SavePath1
	return save_path
