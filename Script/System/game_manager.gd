extends Node
##############
# GameManager
# Autoload
##############
enum GameState{Gameplay,Stop}
var game_state : GameState = GameState.Gameplay

var registered_objects: Dictionary#[String, bool]
var stored_objects: Dictionary#[String, bool]

var player_data : PlayerData = preload("res://Script/Player/Data/player_data_resource.tres")

func set_player_data():
	player_data.current_health = player_data.max_health

func _ready():
	set_player_data()

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
