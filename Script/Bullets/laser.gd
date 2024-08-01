class_name Laser extends RayCast2D

@onready var casting_particles: GPUParticles2D = $CastingParticles
@onready var collision_particles: GPUParticles2D = $CollisionParticles
@onready var beam_particle_2d: GPUParticles2D = $BeamParticle2D
@onready var line_2d: Line2D = $Line2D
@onready var collision_shape_2d: CollisionShape2D = $AttackBox/CollisionShape2D

var width : float

var is_casting: bool = false :
	set(value): 
		is_casting = value
		
		beam_particle_2d.emitting = is_casting
		casting_particles.emitting = is_casting
		collision_particles.emitting = is_casting
		
		if is_casting:
			appear()
		else:
			disapear()
		set_physics_process(is_casting)

func _ready()->void:
	width = line_2d.width
	collision_shape_2d.shape.size.x = target_position.x
	collision_shape_2d.shape.size.y = width + 64
	collision_shape_2d.position = target_position * 0.5

func _physics_process(_delta: float) -> void:
	var cast_point := target_position
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		collision_particles.global_rotation = get_collision_normal().angle()
		collision_particles.position = cast_point
	else:
		collision_particles.position = target_position
	
	line_2d.points[1] = cast_point
	beam_particle_2d.position = cast_point * 0.5
	beam_particle_2d.process_material.emission_box_extents.x = cast_point.length() * 0.5
	beam_particle_2d.process_material.emission_box_extents.y = width

func appear() -> void:
	var tween :Tween = create_tween()
	tween.tween_property(line_2d, "width", width, 0.2)

func disapear() -> void:
	var tween :Tween = create_tween()
	tween.tween_property(line_2d, "width", 0, 0.1)
