extends KinematicBody2D

const UP_DIRECTION := Vector2.DOWN

export var speed := 20.0
export var waterResistance := 20.0
export var jump_gravity := 500.0
export var fall_gravity := 1000.0
export var max_jump := 17.0
export var lightintensity_cone = 0.5
export var lightintensity_circle = 0.5
# TODO back to 25? oder sprite indicator richtig

var jumps_made := 0
var max_jumps := 2
var velocity := Vector2.ZERO # Geschwindigkeit
var jump_height := 0.0
var is_jumping := false
var last_vel := Vector2.ZERO
var max_points := 5
var left = true
var dash_speed = 32.0
var dash_length = .15
var falling = false
var lying = false
var dash_start_point = Vector2.ZERO

enum{
	IDLE,
	JUMPING,
	FALLING,
	FLYING,
	DASHING,
	LYING
}

var state = IDLE

onready var dash = $Dash
onready var line = $DirectionVisualizer
onready var trajPoint = $TrajPoint
onready var cam = $TransitionCam
onready var indicator = $JumpIndicator
onready var animation = $AnimationPlayer
onready var jumpLoad = $Sprite/JumpLoad
onready var sprite = $Sprite
onready var spotlight = $Spotlight
onready var circle_light = $CircleLight

func _ready() -> void:
	animation.play("Idle_Left")
	Global.reg_player(self)
	spotlight.energy = lightintensity_cone
	circle_light.energy = lightintensity_circle

func _physics_process(delta: float) -> void:
	match state:
		IDLE:
			idle_state(delta)
		JUMPING:
			jumping_state(delta)
		FALLING:
			falling_state(delta)
		FLYING:
			flying_state(delta)
		DASHING:
			dashing_state(delta)
		LYING:
			lying_state(delta)

func idle_state(delta):
	sprite.rotation = 0
	indicator.frame = 0
	if position.x < get_global_mouse_position().x:
		animation.play("Idle_Right")
		left = false
		jumpLoad.frame = 0
	else:
		animation.play("Idle_Left")
		left = true
		jumpLoad.frame = 4
	if Input.is_action_pressed("jump"):
		state = JUMPING
	velocity = reduce_vel(delta, velocity)
	turn_spotlight()
	last_vel = velocity
	velocity = move_and_slide(velocity, UP_DIRECTION)
	
func jumping_state(delta):
	sprite.rotation = 0
	velocity = reduce_vel(delta, velocity)
	turn_spotlight()
	if jumps_made < max_jumps:
		if Input.is_action_just_released("jump"):
			Engine.time_scale = 1
			line.clear_points()
			jumps_made += 0 # TODO = 1
			dash_start_point = position
			dash.start_dash(sprite,dash_length)
			do_jump()
			Shake.shake()
			state = DASHING
			indicator.frame = 0
			return
			
		if left:
			sprite.frame = 6
		else:
			sprite.frame = 2
		update_trajectory(delta)
		if jump_height < max_jump:
			jump_height += 1
			indicator.frame = jump_height - 1
		Engine.time_scale = 0.09
	last_vel = velocity
	velocity = move_and_slide(velocity, UP_DIRECTION)
	
func falling_state(delta):
	velocity = reduce_vel(delta, velocity)
	turn_spotlight()
	spotlight.enabled = false
	animation.play("Falling")
	
	if Input.is_action_pressed("jump") and jumps_made < max_jumps:
		state = JUMPING
	
	last_vel = velocity
	velocity = move_and_slide(velocity, UP_DIRECTION)

func flying_state(delta):
	velocity = reduce_vel(delta, velocity)
	turn_spotlight()
	if position.x < get_global_mouse_position().x:
		animation.play("Idle_Right")
		left = false
		jumpLoad.frame = 0
	else:
		animation.play("Idle_Left")
		left = true
		jumpLoad.frame = 4
	if Input.is_action_pressed("jump") and jumps_made < max_jumps:
		state = JUMPING
	if position.y < dash_start_point.y - 20:
		dash_start_point = Vector2.ZERO
		falling = true
		state = FALLING
	

	last_vel = velocity
	velocity = move_and_slide(velocity, UP_DIRECTION)
	
func dashing_state(delta):
	velocity = reduce_vel(delta, velocity)
	turn_spotlight()
	if dash.is_dashing():
		if left:
			animation.play("Dashing_left")
		else:
			animation.play("Dashing_right")
		speed = dash_speed
	if dash.get_stopped():
		var new_vel = Vector2.ZERO
		new_vel.x = velocity.x/2
		new_vel.y = velocity.y/4
		velocity = reduce_vel(delta,new_vel)
		state = FLYING
	last_vel = velocity
	velocity = move_and_slide(velocity, UP_DIRECTION)
	
func lying_state(delta):
	spotlight.enabled = false
	sprite.rotation = 0
	if lying:
		Engine.time_scale = 1
		sprite.frame = 8
		animation.play("Lying")
	else:
		state = IDLE
	velocity = reduce_vel(delta, velocity)
	last_vel = velocity
	velocity = move_and_slide(velocity, UP_DIRECTION)

func do_jump():
	var dir = position.direction_to(get_global_mouse_position())
	velocity = dir*jump_height*speed
	jump_height = 0
	is_jumping = true

func turn_spotlight():
	spotlight.enabled = true
	spotlight.rotation = get_global_mouse_position().angle_to_point(position) - 1.5707963268

func update_trajectory(delta):
	indicator.rotation = get_global_mouse_position().angle_to_point(position) - 1.5707963268

func get_stats():
	return sprite.material.get_shader_param("Amount")

func get_state():
	var val = ""
	match state:
		IDLE:
			val = "IDLE"
		JUMPING:
			val = "JUMPING"
		FALLING:
			val = "FALLING"
		FLYING:
			val = "FLYING"
		DASHING:
			val = "DASHING"
		LYING:
			val = "LYING"
	return val

func get_gravity(vel):
	if vel.y < 0.0:
		return jump_gravity 
	else:
		return fall_gravity

func reduce_vel(delta, vel):
	vel.y = vel.y - get_gravity(vel) * delta # do gravity always
	if is_on_floor():
		if state == FALLING:
			vel.x = 0
			is_jumping = false
			jumps_made = 0
			state = LYING
			sprite.rotation = 0
			lying = true
			$LyingTimer.start()
		elif state == FLYING:
			vel.x = 0
			is_jumping = false
			jumps_made = 0
			state = IDLE
	elif is_on_wall():
		vel.x = -last_vel.x * 0.75
	else:
		if vel.x > 0:
			vel.x = vel.x - waterResistance * delta
		elif vel.x < 0:
			vel.x = vel.x + waterResistance * delta
	return vel


func _on_LyingTimer_timeout() -> void:
	lying = false
