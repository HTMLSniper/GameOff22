extends KinematicBody2D

const UP_DIRECTION := Vector2.DOWN

export var speed := 32.0
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
var jump_height := 0
var is_jumping := false
var last_vel := Vector2.ZERO
var max_points := 5
var left = true
var dash_speed = 32.0
var dash_length = .15
var falling = false
var lying = false
var dash_start_point = Vector2.ZERO
var message = false

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
onready var backpackTimer = $TimerBackpack 
onready var jumpLoad = $Sprite/JumpLoad
onready var sprite = $Sprite
onready var spotlight = $Spotlight
onready var circle_light = $CircleLight
onready var landingPart = $LandingParticles
onready var dashPart = $Sprite/DashParticles
onready var landingSound = $Audio/AudioStreamLanding
onready var fallingSound = $Audio/AudioStreamFalling
onready var bounceSound = $Audio/AudioStreamBounce
onready var lyingSound = $Audio/AudioStreamLying
onready var jumpSound = $Audio/AudioStreamJump

func _ready() -> void:
	Global.reg_player(self)
	spotlight.energy = lightintensity_cone
	circle_light.energy = lightintensity_circle
	change_sprite(Global.sprite_texture)
	Global.connect("sound_changed_live", self, "sound_changed")
	sound_changed()

func _physics_process(delta: float) -> void:
	handle_Backpack()
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
	#if backpackTimer.is_stopped():
		#if jumpLoad.frame != 8 and jumpLoad.frame != 4:
			#backpackTimer.start()
			#pass
		#else:
			#handle_Backpack()
	if add_debug_movement(delta):
		return
	sprite.rotation = 0
	indicator.frame = 0
	update_left()
	if left:
		animation.play("Idle_Left")
	else:
		animation.play("Idle_Right")
	if Input.is_action_pressed("jump"):
		state = JUMPING
		jumpSound.pitch_scale = rand_range(0.8,1.2)
		sound_changed()
		jumpSound.play()
	velocity = reduce_vel(delta, velocity)
	turn_spotlight()
	last_vel = velocity
	velocity = move_and_slide(velocity, UP_DIRECTION, false)
	
func jumping_state(delta):
	if position.y < dash_start_point.y - 20:
		dash_start_point = Vector2.ZERO
		falling = true
		Global.falls += 1
		animation.play("Falling")
	if message:
		$CanvasLayer.visible = false
	sprite.rotation = 0
	velocity = reduce_vel(delta, velocity)
	turn_spotlight()
	if jumps_made < max_jumps:
		if Input.is_action_just_released("jump"):
			Engine.time_scale = 1
			line.clear_points()
			jumps_made += 1
			#handle_Backpack()
			Global.jumps += 1
			dash_start_point = position
			dash.start_dash(sprite,dash_length)
			do_jump()
			Shake.shake_cam(0.4,0.1)
			state = DASHING
			indicator.frame = 0
			if left:
				dashPart.position = Vector2(5,-7)
			else:
				dashPart.position = Vector2(-5,-7)
			dashPart.emitting = true
			dashPart.restart()
			return
		update_left()
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
		jumpSound.pitch_scale = rand_range(0.8,1.2)
		sound_changed()
		jumpSound.play()
	last_vel = velocity
	velocity = move_and_slide(velocity, UP_DIRECTION, false)

func flying_state(delta):
	#handle_Backpack()
	sprite.rotation = 0
	velocity = reduce_vel(delta, velocity)
	turn_spotlight()
	update_left()
	if left:
		animation.play("Idle_Left")
	else:
		animation.play("Idle_Right")
	if Input.is_action_pressed("jump") and jumps_made < max_jumps:
		state = JUMPING
		jumpSound.pitch_scale = rand_range(0.8,1.2)
		sound_changed()
		jumpSound.play()
	if position.y < dash_start_point.y - 20:
		dash_start_point = Vector2.ZERO
		falling = true
		Global.falls += 1
		state = FALLING
		fallingSound.pitch_scale = rand_range(0.5,1.2)
		sound_changed()
		fallingSound.play()
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
	jumpLoad.frame = 0
	if lying:
		Engine.time_scale = 1
		sprite.frame = 8
		animation.play("Lying")
	else:
		#backpackTimer.start()
		#handle_Backpack()
		state = IDLE
	velocity = reduce_vel(delta, velocity)
	last_vel = velocity
	velocity = move_and_slide(velocity, UP_DIRECTION, false)

func update_left():
	if position.x < get_global_mouse_position().x:
		left = false
	else:
		left = true

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
			bounceSound.pitch_scale = rand_range(0.8,1.2)
			sound_changed()
			bounceSound.play()
		elif state == FALLING:
			vel.x = 0
			is_jumping = false
			state = LYING
			lyingSound.pitch_scale = rand_range(0.8,1.2)
			sound_changed()
			lyingSound.play()
			sprite.rotation = 0
			lying = true
			Shake.shake_cam(0.5,0.2)
			floor_particles(20,0.7)
			$LyingTimer.start()
		elif state == FLYING:
			vel.x = 0
			is_jumping = false
			state = IDLE
			landingSound.pitch_scale = rand_range(0.8,1.2)
			sound_changed()
			landingSound.play()
			floor_particles(10,0.2)
		elif state == JUMPING:
			animation.stop()
			vel.x = 0
			is_jumping = false
	elif is_on_wall():
		bounceSound.pitch_scale = rand_range(0.8,1.2)
		sound_changed()
		bounceSound.play()
		vel.x = -last_vel.x * 0.75
		vel.y *= 1.1
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
	if not is_jumping:
		jumps_made = 0
	if state == LYING:
		jumpLoad.frame = 0
		return
	if jumps_made == 2:
		jumpLoad.frame = 0
	elif jumps_made == 1:
		if left:
			jumpLoad.frame = 6
		else:
			jumpLoad.frame = 2
	elif jumps_made == 0:
		if left:
			jumpLoad.frame = 8
		else:
			jumpLoad.frame = 4

func change_spot(val, smooth_val = 10):
	spotlight.energy = val
	spotlight.shadow_filter_smooth = smooth_val

func change_circle(val, smooth_val = 50, tex_scale = 0.3):
	circle_light.energy = val
	circle_light.shadow_filter_smooth = smooth_val
	circle_light.texture_scale = tex_scale

func fadein():
	$TransitionPlayer.play("Fadein")
	if Global.time_played <= 1000:
		message = true
		$CanvasLayer.visible = true
	
func connect_goal():
	var goal = get_parent().find_node("Goal")
	goal.connect("goal_entered", self, "won")

func get_coin():
	Global.change_coins(Global.settings["coins"] + 1)
	print(Global.settings["coins"])

func change_sprite(path):
	sprite.set_texture(path)

func sound_changed():
	if Global.sound_on:
		landingSound.volume_db = Global.sound_vol - 10
		fallingSound.volume_db = Global.sound_vol - 10
		bounceSound.volume_db = Global.sound_vol - 10
		lyingSound.volume_db = Global.sound_vol - 15
		jumpSound.volume_db = Global.sound_vol - 15
	else:
		landingSound.volume_db = -80
		fallingSound.volume_db = -80
		bounceSound.volume_db = -80
		lyingSound.volume_db = -80
		jumpSound.volume_db = -80
		landingSound.stop()
		fallingSound.stop()
		bounceSound.stop()
		lyingSound.stop()
		jumpSound.stop()

func _on_LyingTimer_timeout() -> void:
	lying = false

func _on_TimerBackpack_timeout() -> void:
	update_left()
	if left:
		match jumpLoad.frame:
			1:
				jumpLoad.frame = 5
			2:
				jumpLoad.frame = 6
			3:
				jumpLoad.frame = 7
	else:
		match jumpLoad.frame:
			5:
				jumpLoad.frame = 1
			6:
				jumpLoad.frame = 2
			7:
				jumpLoad.frame = 3
	if jumpLoad.frame == 8 or jumpLoad.frame == 4:
		jumps_made = 0
	else:
		jumpLoad.frame += 1
		backpackTimer.start()

