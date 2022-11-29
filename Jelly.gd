extends Node2D


onready var sprite = $Path2D/PathFollow2D/AnimatedSprite
onready var follow = $Path2D/PathFollow2D

export(int) var random_seed = 0

var inc=0
var speed=10

func _ready() -> void:
	sprite.play("move")
	randomize()
	follow.offset = rand_range(0,800)

func _process(delta: float) -> void:
	sprite.play("move")
	randomize()
	var rand_speed = randi() %30
	#var rand_speed = rand_range(speed - 20,speed + 20)
	inc+=delta*rand_speed
	follow.offset=inc

