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
		DASHING:
			dashing_state(delta)
		LYING:
			lying_state(delta)
	
	if lying:
		Engine.time_scale = 1
		sprite.frame = 8
		animation.play("Lying")
		return
	velocity = reduce_vel(delta, velocity)
	turn_spotlight()
	if dash.is_dashing():
		animation.play("Dashing_right")
		speed = dash_speed
	if dash.get_stopped():
		var new_vel = Vector2.ZERO
		new_vel.x = velocity.x/2
		new_vel.y = velocity.y/4
		velocity = reduce_vel(delta,new_vel)
	if position.y < dash_start_point.y - 20:
		dash_start_point = Vector2.ZERO
		falling = true
	if position.x < get_global_mouse_position().x and not falling and not dash.is_dashing():
		animation.play("Idle_Right")
		left = false
		jumpLoad.frame = 0
	elif falling:
		animation.play("Falling")
	elif dash.is_dashing():
		animation.play("Dashing_right")
	else:
		animation.play("Idle_Left")
		left = true
		jumpLoad.frame = 4
	if jumps_made < max_jumps and not lying:
		if Input.is_action_pressed("jump"):
			if left:
				sprite.frame = 6
			else:
				sprite.frame = 2
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
			jumps_made += 0 # TODO = 1
			dash_start_point = position
			dash.start_dash(sprite,dash_length)
			do_jump()
			Shake.shake()
			
			
	last_vel = velocity
	velocity = move_and_slide(velocity, UP_DIRECTION)

func idle_state(delta):
	pass
	
func jumping_state(delta):
	pass
	
func falling_state(delta):
	pass
	
func dashing_state(delta):
	pass
	
func lying_state(delta):
	pass

func do_jump():
	var dir = position.direction_to(get_global_mouse_position())
	velocity = dir*jump_height*speed
	jump_height = 0
	is_jumping = true

func turn_spotlight():
	spotlight.rotation = get_global_mouse_position().angle_to_point(position) - 1.5707963268

func update_trajectory(delta):
	indicator.rotation = get_global_mouse_position().angle_to_point(position) - 1.5707963268

func get_stats():
	return sprite.material.get_shader_param("Amount")

func get_gravity(vel):
	if vel.y < 0.0:
		return jump_gravity 
	else:
		return fall_gravity

func reduce_vel(delta, vel):
	vel.y = vel.y - get_gravity(vel) * delta # do gravity always
	if is_on_floor():
		if falling:
			falling = false
			lying = true
			sprite.rotation = 0
			$LyingTimer.start()
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


func _on_LyingTimer_timeout() -> void:
	lying = false
