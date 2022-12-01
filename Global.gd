extends Node

const SAVE_FILE_PATH = "user://savedata.save"
const SKIN_FILE_NAME = "user://skinsavedata.save"

signal music_changed_live
signal sound_changed_live
signal coins_changed_live

var bombo = preload("res://assets/bombo.png")

var player : KinematicBody2D
var timeh = 0
var timem = 0
var times = 0
var jumps = 0
var falls = 0
var paused = false
var time_played = 0
var goal : Node2D
var sprite_texture = bombo
var coins = []

var settings = {
	"coins" : 0,
	"skin_crown" : 0,
	"skin_princess" : 0,
	"skin_diver" : 0,
	"skin_amongo" : 0,
	"skin_mario" : 0,
}

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
	save_data.store_var(timeh)
	save_data.store_var(timem)
	save_data.store_var(times)
	save_data.store_var(jumps)
	save_data.store_var(falls)
	save_data.store_var(time_played)
	save_data.store_var(coins)
	save_data.close()

func load_from_file():
	var save_data = File.new()
	if save_data.file_exists(SAVE_FILE_PATH):
		save_data.open(SAVE_FILE_PATH, File.READ)
		player.position.x = save_data.get_var()
		player.position.y = save_data.get_var()
		timeh = save_data.get_var()
		timem = save_data.get_var()
		times = save_data.get_var()
		jumps = save_data.get_var()
		falls = save_data.get_var()
		time_played = save_data.get_var()
		coins = save_data.get_var()
		save_data.close() 

func change_coins(new_number):
	settings["coins"] = new_number
	emit_signal("coins_changed_live")

func reset_everything():
	player.position.x = 286
	player.position.y = 24
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
	

func save():
	var file = File.new()
	file.open(SKIN_FILE_NAME, File.WRITE)
	file.store_var(settings)
	file.store_var(music_vol)
	file.store_var(sound_vol)
	file.store_var(music_on)
	file.store_var(sound_on)
	file.close()
	
func load():
	var file = File.new()
	if file.file_exists(SKIN_FILE_NAME):
		file.open(SKIN_FILE_NAME, File.READ)
		#var data = parse_json(file.get_as_text()
		var data = file.get_var()
		music_vol = file.get_var()
		sound_vol = file.get_var()
		music_on = file.get_var()
		sound_on = file.get_var()
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			settings = data
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")
	print(settings)
