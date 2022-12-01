extends Node2D

onready var timer = $Timer
onready var ghostTimer = $GhostTimer
onready var dashSound = $AudioStreamPlayer

var ghost_scene = preload("res://DashGhost.tscn")

var stopped = false
var sprite

func start_dash(sprite_dh, dur):
	dashSound.pitch_scale = rand_range(0.8,1.2)
	sound_changed()
	dashSound.play()
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

func sound_changed():
	if Global.sound_on:
		dashSound.volume_db = Global.sound_vol - 10
	else:
		dashSound.volume_db = -80

func _on_Timer_timeout() -> void:
	stopped = true
	ghostTimer.stop()


func _on_GhostTimer_timeout() -> void:
	instance_ghost()
