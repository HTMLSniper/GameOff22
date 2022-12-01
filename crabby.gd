extends Node2D

onready var sprite = $Path2D/PathFollow2D/AnimatedSprite
onready var follow = $Path2D/PathFollow2D


var inc = 0
var speed = 25
var maxdistance_to_sprite = 75
var min_scale_factor = 17
var scale_factor = 2.5
var max_scale_factor = 32 # int

func _ready() -> void:
	sprite.play("move")
	inc = rand_range(0,350)
	follow.offset = inc
	scale_factor = rand_range(min_scale_factor,max_scale_factor) / 10
	sprite.scale.x = scale_factor
	sprite.scale.y = scale_factor

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
		if Global.player.position.y < sprite.global_position.y:
			sprite.play("fight")
		else:
			sprite.play("move")
	else: 
		sprite.play("move")
