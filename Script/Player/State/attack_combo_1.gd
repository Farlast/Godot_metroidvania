extends State

@onready var attack_box : CollisionShape2D = %AttackArea
@export var attack_audio : AudioStreamPlayer2D

var active_input : bool
var attack_buffer : bool  = false
var listen_input_window : bool 
var lock_movement : bool
var direction : float

func _ready():
	super._ready()
	animator.animation_finished.connect(on_animation_finish)
	player.attack_success.connect(on_attack_success)

############
## Custom
############
func next_state():
	if player.is_on_floor() : 
		transition.emit(self,"Idle")
	else :
		transition.emit(self,"fall")

func on_attack_success():
	if not active_input: return
	
	if player.get_hit_direction != Vector2.ZERO:
		player.velocity.x = player.knockback_force/2 * -player.get_hit_direction.x

func on_animation_finish(_animation_name : String):
	disable_hitbox()
	if not active_input: return
	next_state()

### call by animation
func enable_hitbox():
	attack_box.set_deferred("disabled",false)

func disable_hitbox():
	attack_box.set_deferred("disabled",true)

func allow_next_animation():
	### allow exit state before animation finish
	listen_input_window = true
	if not active_input: return
	if attack_buffer:
		attack_buffer = false
		lock_movement = true
		listen_input_window = false
		player.velocity = Vector2(player.direction_holder.scale.x * 120,0)
		start_attack()

func start_attack():
	animator.play("attack")
	if attack_audio: attack_audio.play()
	
	player.velocity = Vector2(player.direction_holder.scale.x * 120,0)
