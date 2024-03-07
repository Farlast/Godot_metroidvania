extends EnemyState
class_name EnemyDigUnderground

@export var move_speed : float = 200
@export var attack_duration : float = 1.0

var attack_timer : float
var boss : EldritchWorm

var attack_ready : bool
var attacked : bool
var animation_finished : bool

func _ready():
	super._ready()
	boss = agent as EldritchWorm

func on_enter():
	attack_timer = 0
	attacked = false
	attack_ready = false
	animation_finished = false
	animator.play("attack_from_under")
	await animator.animation_finished
	animation_finished = true

func on_exit():
	pass

func on_update(_delta : float):
	if boss.target == null: return
	if not animation_finished: return
	if not attack_ready:
		move_to_target(_delta)
		attack_timer += _delta
		if attack_timer >= attack_duration:
			attack_ready = true
	elif not attacked:
		attacked = true
		boss.velocity.x = 0
		await get_tree().create_timer(0.5).timeout
		animator.play_backwards("attack_from_under")
		await animator.animation_finished
		transition.emit(self,"idle")

func on_physics_update(_delta : float):
	boss.move_and_slide()

func move_to_target(_delta : float):
	if boss.target == null:return
	if boss.target.global_position.x > boss.global_position.x:
		#turn_right
		boss.velocity.x = 1 * move_speed
	else:
		#turn_left
		boss.velocity.x = -1 * move_speed
	
