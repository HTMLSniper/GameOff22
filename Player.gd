extends KinematicBody2D

const UP_DIRECTION := Vector2.DOWN

export var speed := 20.0
export var waterResistance := 20.0
export var jump_gravity := 500.0
export var fall_gravity := 1000.0
export var max_jump := 25.0

var jumps_made := 0.0
var velocity := Vector2.ZERO # Geschwindigkeit
var jump_height := 0.0
var is_jumping := false
var last_vel := Vector2.ZERO


func _physics_process(delta: float) -> void:
	reduce_vel(delta)

	if Input.is_action_pressed("jump"):
		print(jump_height)
		if jump_height < max_jump:
			jump_height += 1
		Engine.time_scale = 0.01
	
	if Input.is_action_just_released("jump"):
		Engine.time_scale = 1
		do_jump()
	print(velocity)
	last_vel = velocity
	velocity = move_and_slide(velocity, UP_DIRECTION)

func do_jump():
	var dir = position.direction_to(get_viewport().get_mouse_position())
	velocity = dir*jump_height*speed
	jump_height = 0
	is_jumping = true
	

func get_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func reduce_vel(delta):
	velocity.y = velocity.y - get_gravity() * delta # do gravity always
	if is_on_floor():
		velocity.x = 0
		is_jumping = false
	elif is_on_wall():
		velocity.x = -last_vel.x * 0.85
	else:
		if velocity.x > 0:
			velocity.x = velocity.x - waterResistance * delta
		elif velocity.x < 0:
			velocity.x = velocity.x + waterResistance * delta
