class_name FootstepsContainer extends Resource

enum GroundType {GRASS,ROCK,GRAVLE,SAND,WATER}

@export var ground_type : GroundType
@export_category("Run")
@export var run_audios : Array[AudioStream]
@export_category("Jump")
@export var jump_audios : Array[AudioStream]
@export_category("land")
@export var land_sound : AudioStream

func get_run_audio() -> AudioStream:
	var index :int= randi_range(0,run_audios.size()-1)
	return run_audios[index]

func get_jump_audio() -> AudioStream:
	var index :int= randi_range(0,jump_audios.size()-1)
	return jump_audios[index]

func get_land_audio() -> AudioStream:
	return land_sound
