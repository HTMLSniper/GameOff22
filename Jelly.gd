extends Node2D


onready var sprite = $Path2D/PathFollow2D/AnimatedSprite
onready var follow = $Path2D/PathFollow2D


var inc = 0
var speed = 10

func _ready() -> void:
	sprite.play("move")
	inc = randi() % 800

func _process(delta: float) -> void:
	sprite.play("move")
	var rand_speed = rand_range(speed - 10,speed + 20)
	inc+=delta*rand_speed
	follow.offset=inc

