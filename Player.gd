extends KinematicBody2D

const UP_DIRECTION := Vector2.DOWN

export var speed := 20.0
export var waterResistance := 20.0
export var jump_gravity := 500.0
export var fall_gravity := 1000.0
export var max_jump := 17.0
# TODO back to 25? oder sprite indicator richtig

var jumps_made := 0
var max_jumps := 2
var velocity := Vector2.ZERO # Geschwindigkeit
var jump_height := 0.0
var is_jumping := false
var last_vel := Vector2.ZERO
var max_points := 5

onready var line = $DirectionVisualizer
onready var trajPoint = $TrajPoint
onready var cam = $TransitionCam
onready var indicator = $JumpIndicator


func _physics_process(delta: float) -> void:
	velocity = reduce_vel(delta, velocity)
	
	if jumps_made < max_jumps:
		if Input.is_action_pressed("jump"):
			update_trajectory(delta)
			if jump_height < max_jump:
				jump_height += 1
				indicator.frame = jump_height - 1
			Engine.time_scale = 0.09
		else:
			indicator.frame = 0
			#update_trajectory(delta)
		if Input.is_action_just_released("jump"):
			
			Engine.time_scale = 1
			line.clear_points()
			jumps_made += 1
			do_jump()
	last_vel = velocity
	velocity = move_and_slide(velocity, UP_DIRECTION)

func do_jump():
	var dir = position.direction_to(get_global_mouse_position())
	velocity = dir*jump_height*speed
	jump_height = 0
	is_jumping = true



func update_trajectory(delta):
	indicator.rotation = get_global_mouse_position().angle_to_point(position) - 1.5707963268
	print(indicator.rotation)
	print(position)
	print(get_global_mouse_position())
#	line.clear_points()
#	var start_pos = Vector2(trajPoint.position.x,trajPoint.position.y-8)
#	var end_pos = Vector2(transform.xform_inv(get_global_mouse_position()).x, transform.xform_inv(get_global_mouse_position()).y - 8)
#	line.add_point(start_pos)
#	line.add_point(end_pos)
	

func get_gravity(vel):
	if vel.y < 0.0:
		return jump_gravity 
	else:
		return fall_gravity

func reduce_vel(delta, vel):
	vel.y = vel.y - get_gravity(vel) * delta # do gravity always
	if is_on_floor():
		vel.x = 0
		is_jumping = false
		jumps_made = 0
	elif is_on_wall():
		vel.x = -last_vel.x * 0.75
	else:
		if vel.x > 0:
			vel.x = vel.x - waterResistance * delta
		elif vel.x < 0:
			vel.x = vel.x + waterResistance * delta
	return vel
