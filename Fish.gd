extends Node2D

onready var sprite = $Path2D/PathFollow2D/AnimatedSprite
onready var follow = $Path2D/PathFollow2D


var inc=0
var speed=25
var start_offset

func _ready() -> void:
	sprite.play("move right")
	#randomize()
	start_offset = randi() % 660
	inc = start_offset
	#$Label.text = "Start: " + String(start_offset)

func _process(delta: float) -> void:
	#$Label.text = "Offset: " + String(follow.offset)
	if follow.offset <= 275:
		sprite.play("move right")
	elif follow.offset > 600:
		sprite.play("move right")
	else:
		sprite.play("move left") 
	var rand_speed = rand_range(speed - 10,speed + 20)
	inc+=delta*rand_speed
	follow.offset=inc
