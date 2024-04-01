class_name Slide
extends State

@export var overhead_ray : RayCast2D
@export var body_collision : CollisionShape2D
@export var minimum_slide_time : float = 0.5
@export var slide_velocity_x : float = 500
@export var slide_cooldown_time : float = 0.5
@export var curve : Curve

var collision_shape : CapsuleShape2D
var defualt_position : Vector2 = Vector2(0,-56)
var defualt_height : float = 112
var slide_position : Vector2 = Vector2(0,-32)
var slide_height : float = 62

var active_input : bool
var slide_timer : float
var slide_finish : bool

func _ready():
	super._ready()
	collision_shape = body_collision.shape as CapsuleShape2D

func on_enter():
	super.on_enter()
	overhead_ray.enabled = true
	active_input = true
	slide_finish = false
	slide_timer = 0
	collision_shape.height = slide_height
	body_collision.position = slide_position
	player.velocity = Vector2(player.direction_holder.scale.x * slide_velocity_x,player.velocity.y)
	animator.play("slide")
	await get_tree().create_timer(slide_timer).timeout
	slide_finish = true

func on_exit():
	super.on_exit()
	overhead_ray.enabled = false
	slide_finish = false
	slide_timer = 0
	collision_shape.height = defualt_height
	body_collision.position = defualt_position
	player.slide_cooldown(slide_cooldown_time)

func on_update(_delta : float):
	super.on_update(_delta)
	if not overhead_ray.is_colliding():
		player.velocity = Vector2(
			player.direction_holder.scale.x * curve.sample(slide_timer) * slide_velocity_x
			,player.velocity.y)
	if slide_timer > minimum_slide_time and not overhead_ray.is_colliding():
		transition.emit(self,"crouch")
	
	slide_timer += _delta

func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
	player.add_fall_gravity(_delta)
	player.move_and_slide()

