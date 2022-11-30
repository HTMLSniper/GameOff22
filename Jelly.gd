extends Node2D


onready var sprite = $Path2D/PathFollow2D/AnimatedSprite
onready var follow = $Path2D/PathFollow2D



var inc=0
var speed=10
var start_offset
var min_scale_factor = 1.3
var scale_factor = 2.5
var max_scale_factor = 35 # int 

func _ready() -> void:
	sprite.play("move")
	#randomize()
	start_offset = randi() % 800
	inc = start_offset
	scale_factor = (randi() % max_scale_factor) / 10
	if scale_factor <= min_scale_factor: 
		scale_factor += 1
	sprite.scale.x = scale_factor
	sprite.scale.y = scale_factor
	#$Label.text = "Start: " + String(start_offset)

func _process(delta: float) -> void:
	sprite.play("move")
	var rand_speed = rand_range(speed - 10,speed + 20)
	inc+=delta*rand_speed
	follow.offset=inc

