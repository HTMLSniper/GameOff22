extends Node2D

onready var timer = $Timer
onready var ghostTimer = $GhostTimer
var ghost_scene = preload("res://DashGhost.tscn")
var stopped = false
var sprite

func start_dash(sprite_dh, dur):
	self.sprite = sprite_dh
	timer.wait_time = dur
	timer.start()
	ghostTimer.start()
	instance_ghost()

func is_dashing():
	return timer.is_stopped()

func get_stopped():
	if stopped:
		stopped = false
		return true
	return false

func instance_ghost():
	var ghost = ghost_scene.instance()
	get_parent().get_parent().add_child(ghost)
	
	ghost.global_position = global_position
	ghost.texture = sprite.texture
	ghost.vframes = sprite.vframes
	ghost.hframes = sprite.hframes
	ghost.rotation = sprite.rotation
	
	ghost.frame = sprite.frame
	

func _on_Timer_timeout() -> void:
	stopped = true
	ghostTimer.stop()


func _on_GhostTimer_timeout() -> void:
	instance_ghost()
