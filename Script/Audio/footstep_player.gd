class_name FootstepPlayer extends Node2D

@onready var ray : RayCast2D = $RayCast2D
@export var footsteps : Array[FootstepsContainer]
@export var volume_db : float = 0
var audio_player: AudioPlayer
var footsteps_dic : Dictionary # <ground_type,FootstepsContainer>
var current_ground_type : FootstepsContainer.GroundType

func _ready()->void:
	audio_player = GameManager.audio_player
	for item:FootstepsContainer in footsteps:
		footsteps_dic[item.ground_type] = item
	current_ground_type = FootstepsContainer.GroundType.ROCK

func  _process(_delta:float)->void:
	current_ground_type = check_groud_type()

#region Ground/Air
### ============== get call from animation ==============
func play_run_audio()->void:
	if not footsteps_dic.has(current_ground_type): return
	var container :FootstepsContainer = footsteps_dic[current_ground_type]
	audio_player.play(container.get_run_audio(),global_position,volume_db)

func play_jump()->void:
	if not footsteps_dic.has(current_ground_type): return
	var container :FootstepsContainer = footsteps_dic[current_ground_type]
	audio_player.play(container.get_jump_audio(),global_position,volume_db)

func play_land()->void:
	if not footsteps_dic.has(current_ground_type): return
	var container :FootstepsContainer = footsteps_dic[current_ground_type]
	audio_player.play(container.get_land_audio(),global_position,volume_db)

func check_groud_type() -> FootstepsContainer.GroundType:
	if ray.is_colliding():
		var body := ray.get_collider()
		if body is Ground:
			return body.type
	return current_ground_type
#endregion
