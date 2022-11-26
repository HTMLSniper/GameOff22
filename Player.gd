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
var max_jumps := 200
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

signal game_won

onready var dash = $Dash
onready var line = $DirectionVisualizer
onready var trajPoint = $TrajPoint
onready var cam = $TransitionCam
onready var indicator = $JumpIndicator
onready var animation = $AnimationPlayer
onready var animation_back = $AnimationPlayerBack
onready var jumpLoad = $Sprite/JumpLoad
onready var sprite = $Sprite
onready var spotlight = $Spotlight
onready var circle_light = $CircleLight
onready var landingPart = $LandingParticles
onready var dashPart = $Sprite/DashParticles

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
	if add_debug_movement(delta):
		return
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
	velocity = move_and_slide(velocity, UP_DIRECTION, false)
	
func jumping_state(delta):
	sprite.rotation = 0
	velocity = reduce_vel(delta, velocity)
	turn_spotlight()
	if jumps_made < max_jumps:
		if Input.is_action_just_released("jump"):
			Engine.time_scale = 1
			line.clear_points()
			jumps_made += 1
			handle_Backpack()
			Global.jumps += 1
			dash_start_point = position
			dash.start_dash(sprite,dash_length)
			do_jump()
			Shake.shake(0.4,0.1)
			state = DASHING
			indicator.frame = 0
			if left:
				dashPart.position = Vector2(5,-7)
			else:
				dashPart.position = Vector2(-5,-7)
			dashPart.emitting = true
			dashPart.restart()
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
	velocity = move_and_slide(velocity, UP_DIRECTION, false)
	
func falling_state(delta):
	velocity = reduce_vel(delta, velocity)
	turn_spotlight()
	spotlight.enabled = false
	animation.play("Falling")
	if Input.is_action_pressed("jump") and jumps_made < max_jumps:
		state = JUMPING
	
	last_vel = velocity
	velocity = move_and_slide(velocity, UP_DIRECTION, false)

func flying_state(delta):
	sprite.rotation = 0
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
		Global.falls += 1
		state = FALLING
	

	last_vel = velocity
	velocity = move_and_slide(velocity, UP_DIRECTION, false)
	
func dashing_state(delta):
	sprite.rotation = 0
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
	velocity = move_and_slide(velocity, UP_DIRECTION, false)
	
func lying_state(delta):
	spotlight.enabled = false
	sprite.rotation = 0
	if lying:
		Engine.time_scale = 1
		sprite.frame = 8
		animation.play("Lying")
	else:
		handle_Backpack_Animation()
		state = IDLE
	velocity = reduce_vel(delta, velocity)
	last_vel = velocity
	velocity = move_and_slide(velocity, UP_DIRECTION, false)

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
	return jumpLoad.frame

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
		if is_slope():
			pass
		elif state == FALLING:
			vel.x = 0
			is_jumping = false
			state = LYING
			sprite.rotation = 0
			lying = true
			Shake.shake(0.5,0.2)
			floor_particles(20,0.7)
			$LyingTimer.start()
		elif state == FLYING:
			vel.x = 0
			is_jumping = false
			state = IDLE
			handle_Backpack_Animation()
			floor_particles(10,0.2)
		elif state == JUMPING:
			vel.x = 0
			is_jumping = false
			handle_Backpack_Animation()
	elif is_on_wall():
		vel.x = -last_vel.x * 0.75
		if vel.x < last_vel.x:
			# bounce left wall
			landingPart.position = Vector2(8,0)
			landingPart.rotation = 90
		else:
			# right wall
			landingPart.position = Vector2(-8,0)
			landingPart.rotation = -90
		landingPart.amount = 15
		landingPart.lifetime = 0.5
		landingPart.emitting = true
		landingPart.restart()
	else:
		if vel.x > 0:
			vel.x = vel.x - waterResistance * delta
		elif vel.x < 0:
			vel.x = vel.x + waterResistance * delta
	return vel

func floor_particles(amount, lifetime):
	landingPart.amount = amount
	landingPart.lifetime = lifetime
	landingPart.position = Vector2(0,-8)
	landingPart.rotation = 0
	landingPart.emitting = true
	landingPart.restart()

func is_slope():
	var angle = get_floor_angle(UP_DIRECTION)
	if angle != 0:
		return true
	return false

func add_debug_movement(delta):
	if Input.is_action_pressed("up"):
		position = position.move_toward(get_global_mouse_position(), delta * 300)
		turn_spotlight()
		return true
	return false

func won():
	$TransitionPlayer.play("Fadeout")
	
func fadeout_done():
	emit_signal("game_won")

func handle_Backpack():
	if jumps_made == 2:
		jumpLoad.visible = false
	elif jumps_made == 1:
		jumpLoad.visible = true
		if left:
			jumpLoad.frame = 5
		else:
			jumpLoad.frame = 1
	else:
		if left:
			jumpLoad.frame = 7
		else:
			jumpLoad.frame = 3

func handle_Backpack_Animation():
	if jumps_made == 2:
		jumpLoad.visible = true
		if left:
			animation_back.play("Low_to_full_left")
			print("looe left")
		else:
			animation_back.play("Low_to_full_right")
			print("low right")
	elif jumps_made == 1:
		jumpLoad.visible = true
		if left:
			animation_back.play("Mid_to_full_left")
			print("mid left")
		else:
			animation_back.play("Mid_to_full_right")
			print("mid right")
	else:
		if left:
			jumpLoad.frame = 7
		else:
			jumpLoad.frame = 3
		jumps_made = 0

func set_jumpsmade_zero():
	jumps_made = 0
	print("reduced")

func fadein():
	$TransitionPlayer.play("Fadein")
	
func connect_goal():
	var goal = get_parent().find_node("Goal")
	goal.connect("goal_entered", self, "won")

func get_coin():
	Global.coins += 1

func _on_LyingTimer_timeout() -> void:
	lying = false
