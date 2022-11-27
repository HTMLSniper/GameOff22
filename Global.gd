extends Node

const SAVE_FILE_PATH = "user://savedata.save"

signal music_changed_live
signal sound_changed_live

var player : KinematicBody2D
var coins = 0
var timeh = 0
var timem = 0
var times = 0
var jumps = 0
var falls = 0
var paused = false
var time_played = 0
var goal : Node2D

var music_vol : float = 50.0
var sound_vol : float = 50.0
var music_on : bool = true
var sound_on : bool = false


func reg_player(node):
	player = node

func reg_goal(node):
	goal = node


func save_to_file():
	var save_data = File.new()
	save_data.open(SAVE_FILE_PATH, File.WRITE)
	save_data.store_var(player.position.x)
	save_data.store_var(player.position.y)
	save_data.store_var(coins)
	save_data.store_var(timeh)
	save_data.store_var(timem)
	save_data.store_var(times)
	save_data.store_var(jumps)
	save_data.store_var(falls)
	save_data.store_var(time_played)
	save_data.close()

func load_from_file():
	var save_data = File.new()
	if save_data.file_exists(SAVE_FILE_PATH):
		save_data.open(SAVE_FILE_PATH, File.READ)
		player.position.x = save_data.get_var()
		player.position.y = save_data.get_var()
		coins = save_data.get_var()
		timeh = save_data.get_var()
		timem = save_data.get_var()
		times = save_data.get_var()
		jumps = save_data.get_var()
		falls = save_data.get_var()
		time_played = save_data.get_var()
		save_data.close() 

func reset_everything():
	player.position.x = 286
	player.position.y = 24
	coins = 0
	timeh = 0
	timem = 0
	times = 0
	jumps = 0
	falls = 0
	time_played = 0
	paused = false

func change_music(value):
	music_vol = value
	if value == 0:
		music_on = false
	else:
		music_on = true
	emit_signal("music_changed_live")

func change_sound(value):
	sound_vol = value
	if value == 0:
		sound_on = false
	else:
		sound_on = true
	emit_signal("sound_changed_live")
