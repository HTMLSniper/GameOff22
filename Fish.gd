extends Node2D

onready var sprite = $Path2D/PathFollow2D/AnimatedSprite
onready var follow = $Path2D/PathFollow2D
onready var shadow_right = $Path2D/PathFollow2D/AnimatedSprite/Right_LightOccluder
onready var shadow_left = $Path2D/PathFollow2D/AnimatedSprite/Left_LightOccluder


var inc = 0
var speed = 25
var min_scale_factor = 13
var scale_factor = 2.5
var max_scale_factor = 32 # int

func _ready() -> void:
	sprite.play("move right")
	inc = randi() % 660
	follow.offset = inc
	scale_factor = rand_range(min_scale_factor,max_scale_factor) / 10
	sprite.scale.x = scale_factor
	sprite.scale.y = scale_factor


func _process(delta: float) -> void:
	if follow.offset <= 275:
		sprite.play("move right")
		shadow_right.visible = true
		shadow_left.visible = false
	elif follow.offset > 600:
		sprite.play("move right")
		shadow_right.visible = true
		shadow_left.visible = false
	else:
		sprite.play("move left")
		shadow_right.visible = false
		shadow_left.visible = true 
	var rand_speed = rand_range(speed - 10,speed + 20)
	inc+=delta*rand_speed
	follow.offset=inc
