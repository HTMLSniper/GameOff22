extends KinematicBody2D

const UP_DIRECTION := Vector2.DOWN

export var speed := 600.0
export var jump_strength := 1500.0
export var maximum_jumps := 3
export var double_jump_strength := 1200.0
export var gravity := 4500.0

var jumps_made := 0
var velocity := Vector2.ZERO # Geschwindigkeit

#onready var pivot: Node2D = $ColorRect
#onready var start_scale: Vector2 = pivot.scale

func _physics_process(delta: float) -> void:
	var horizonzal_direction = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	velocity.x = horizonzal_direction * speed
	velocity.y = velocity.y - gravity * delta
	
	var is_falling := velocity.y < 0.0 and not is_on_ceiling()
	var is_jumping := Input.is_action_just_pressed("jump") and is_on_ceiling()
	var is_double_jumping := Input.is_action_just_pressed("jump") and is_falling
	var is_jump_cancelled := Input.is_action_just_pressed("jump") and velocity.y < 0.0
	var is_idling := is_on_ceiling() and is_zero_approx(velocity.x)
	var is_running := is_on_ceiling() and not is_zero_approx(velocity.x)
	
	if is_jumping:
		jumps_made += 1
		velocity.y = +jump_strength
	elif is_double_jumping:
		jumps_made += 1
		if jumps_made <= maximum_jumps:
			velocity.y = +double_jump_strength
	elif is_jump_cancelled:
		velocity.y = 0.0
	elif is_idling or is_running:
		jumps_made = 0
	
	velocity = move_and_slide(velocity, UP_DIRECTION)

