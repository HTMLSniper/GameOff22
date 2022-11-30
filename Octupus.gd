extends Node2D


onready var sprite = $Path2D/PathFollow2D/AnimatedSprite
onready var follow = $Path2D/PathFollow2D
onready var shadow_right = $Path2D/PathFollow2D/AnimatedSprite/Right_LightOccluder
onready var shadow_left = $Path2D/PathFollow2D/AnimatedSprite/Left_LightOccluder


export(int) var random_seed = 0

var inc=0
var speed=25

func _ready() -> void:
	sprite.play("move")
	inc = rand_range(0,1300)

func _process(delta: float) -> void:
	sprite.play("move")
	var rand_speed = randi() %30
	#var rand_speed = rand_range(speed - 20,speed + 20)
	inc+=delta*rand_speed
	var old_pos = sprite.global_position
	follow.offset=inc
	var direction = sprite.global_position - old_pos
	if direction.x < 0:
		sprite.flip_h = true
		shadow_right.visible = false
		shadow_left.visible = true
	elif direction.x > 0:
		sprite.flip_h = false
		shadow_right.visible = true
		shadow_left.visible = false
	else:
		pass
	
