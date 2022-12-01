extends Node2D


onready var sprite = $Path2D/PathFollow2D/AnimatedSprite
onready var follow = $Path2D/PathFollow2D
onready var light = $Path2D/PathFollow2D/AnimatedSprite/Light2D

export var lightintensity_circle = 0.5

var inc = 0
var speed=10
var min_scale_factor = 16
var scale_factor = 2.5
var max_scale_factor = 32 # int

func _ready() -> void:
	sprite.play("move")
	inc = randi() % 800
	follow.offset = inc
	scale_factor = rand_range(min_scale_factor,max_scale_factor) / 10
	sprite.scale.x = scale_factor
	sprite.scale.y = scale_factor
	light.energy = lightintensity_circle

func _process(delta: float) -> void:
	sprite.play("move")
	var rand_speed = rand_range(speed - 10,speed + 20)
	inc+=delta*rand_speed
	follow.offset=inc

