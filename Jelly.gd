extends Node2D


onready var sprite = $Path2D/PathFollow2D/AnimatedSprite
onready var follow = $Path2D/PathFollow2D


var inc=0
var speed=10
var start_offset

func _ready() -> void:
	sprite.play("move")
	#randomize()
	start_offset = randi() % 800
	inc = start_offset
	#$Label.text = "Start: " + String(start_offset)

func _process(delta: float) -> void:
	#$Label.text = "Offset: " + String(follow.offset)
	sprite.play("move")
	var rand_speed = rand_range(speed - 10,speed + 20)
	inc+=delta*rand_speed
	follow.offset=inc

