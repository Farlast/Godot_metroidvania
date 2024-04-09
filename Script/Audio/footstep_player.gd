class_name FootstepPlayer extends Node2D

@export var ray : RayCast2D
@export var footsteps : Array[FootstepsContainer]
var footsteps_dic : Dictionary # <ground_type,FootstepsContainer>

var current_ground_type : FootstepsContainer.GroundType
var audio_player: AudioPlayer

func _ready():
	audio_player = GameManager.audio_player
	for item:FootstepsContainer in footsteps:
		footsteps_dic[item.ground_type] = item
	footsteps.clear()
	current_ground_type = FootstepsContainer.GroundType.ROCK

func  _process(_delta):
	current_ground_type = check_groud_type()

#region Ground/Air
### ============== get call from animation ==============
func play_run_audio():
	if not footsteps_dic.has(current_ground_type): return
	var container :FootstepsContainer = footsteps_dic[current_ground_type]
	audio_player.play(container.get_run_audio(),global_position)

func play_jump():
	var container :FootstepsContainer = footsteps_dic[current_ground_type]
	audio_player.play(container.get_jump_audio(),global_position)

func play_land():
	var container :FootstepsContainer = footsteps_dic[current_ground_type]
	audio_player.play(container.get_land_audio(),global_position)

func check_groud_type() -> FootstepsContainer.GroundType:
	if ray.is_colliding():
		var body = ray.get_collider()
		if body is Ground:
			return body.type
	return current_ground_type
#endregion
