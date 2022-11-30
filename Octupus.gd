extends Node2D


onready var sprite = $Path2D/PathFollow2D/AnimatedSprite
onready var follow = $Path2D/PathFollow2D


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
	elif direction.x > 0:
		sprite.flip_h = false
	else:
		pass
