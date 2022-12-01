extends Node2D

onready var sprite = $Path2D/PathFollow2D/AnimatedSprite
onready var follow = $Path2D/PathFollow2D
onready var shadow_right = $Path2D/PathFollow2D/AnimatedSprite/Right_LightOccluder
onready var shadow_left = $Path2D/PathFollow2D/AnimatedSprite/Left_LightOccluder
onready var light = $Path2D/PathFollow2D/AnimatedSprite/Light2D

export var lightintensity_circle = 0.5

var inc = 0
var speed = 25
var min_scale_factor = 16
var scale_factor = 2.5
var max_scale_factor = 31 # int

func _ready() -> void:
	sprite.play("move")
	inc = rand_range(0,1300)
	follow.offset = inc
	scale_factor = rand_range(min_scale_factor,max_scale_factor) / 10
	sprite.scale.x = scale_factor
	sprite.scale.y = scale_factor
	light.energy = lightintensity_circle

func _process(delta: float) -> void:
	sprite.play("move")
	var rand_speed = randi() %30
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
	
