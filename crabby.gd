extends Node2D

onready var sprite = $Path2D/PathFollow2D/AnimatedSprite
onready var follow = $Path2D/PathFollow2D


var inc = 0
var speed = 25
var maxdistance_to_sprite = 75

func _ready() -> void:
	sprite.play("move")
	inc = rand_range(0,350)

func _process(delta: float) -> void:
	var rand_speed = randi() %30
	inc+=delta*rand_speed
	follow.offset=inc
	if follow.offset < 175:
		sprite.flip_h = false
	elif follow.offset > 175:
		sprite.flip_h = true
	else:
		pass
	if sprite.global_position.distance_to(Global.player.position) < maxdistance_to_sprite:
		sprite.play("fight")
	else: 
		sprite.play("move")
