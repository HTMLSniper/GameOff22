extends Node2D

onready var goal = $Goal
onready var debug_overlay = $DebugOverlay
onready var animation = $AnimationPlayer
onready var hud = $CanvasLayer/HUD
onready var gamefinished = $CanvasLayer/GameFinished
onready var canvas_modulate = $CanvasModulate
onready var music = $MusicStreamPlayer
onready var music2 = $MusicStreamPlayer2
onready var music3 = $MusicStreamPlayer3
onready var music4 = $MusicStreamPlayer4
onready var coinUD = $CanvasLayer/HUD/CoinUD
onready var tween = $MusicTween

var nextMusic = 1
var last_pos = 0
var transitioning = false


func _ready() -> void:
	Global.player.connect("game_won", self, "won")
	Global.connect("music_changed_live", self, "music_changed")
	music.play()
	Global.load_from_file()
	Global.player.connect_goal()
	Shake.set_cam()
	#add_debug_stats()
	Global.player.fadein()

func _process(delta: float) -> void:
	change_color_for_depth(Global.player, delta)
#	if not Global.music_on:
#		return
#	if music.get_playback_position() > 41.0 and not transitioning:
#		tween.interpolate_property(music, "volume_db", Global.music_vol - 30, -80, 2,0,0)
#		tween.start()
#	elif music2.get_playback_position() > 78.0 and not transitioning:
#		tween.interpolate_property(music2, "volume_db", Global.music_vol - 30, -80, 2,0,0)
#		tween.start()
#	elif music3.get_playback_position() > 94.0 and not transitioning:
#		tween.interpolate_property(music3, "volume_db", Global.music_vol - 30, -80, 2,0,0)
#		tween.start()
#	elif music4.get_playback_position() > 106.0 and not transitioning:
#		tween.interpolate_property(music4, "volume_db", Global.music_vol - 30, -80, 2,0,0)
#		tween.start()
#	transitioning = true

func add_debug_stats():
	debug_overlay.visible = true
	debug_overlay.add_stat("FPS", Engine, "get_frames_per_second", true)
	debug_overlay.add_stat("Player position", $Player, "position", false)
	debug_overlay.add_stat("Player state", $Player, "get_state", true)
	debug_overlay.add_stat("Player velocity", $Player, "velocity", false)
	debug_overlay.add_stat("Player jumping", $Player, "is_jumping", false)
	debug_overlay.add_stat("Player jumps made", $Player, "jumps_made", false)
	debug_overlay.add_stat("Player backpack frame", $Player, "get_stats", true)
	debug_overlay.add_stat("Player jump height", $Player, "jump_height", false)
	debug_overlay.add_stat("Player on floor", $Player, "is_on_floor", true)
	debug_overlay.add_stat("Coins", Global, "coins", false)
	debug_overlay.add_stat("Time played", Global, "time_played", false)
	debug_overlay.add_stat("GMin", Global, "timem", false)
	debug_overlay.add_stat("GSec", Global, "times", false)
	debug_overlay.add_stat("Timer Zero", $CanvasLayer/HUD/Timer, "time_zero", false)
	debug_overlay.add_stat("Current Time", Time, "get_time_dict_from_system", true)
	debug_overlay.add_stat("Player Shader", $Player, "get_stats", true)

func change_color_for_depth(player, delta):
	# not nice but works
	var pos = player.position.y
	var tween = $CanvasModulate/Tween
	if pos < 700:
		canvas_modulate.color = canvas_modulate.color.linear_interpolate("ffffff", delta)
		player.change_spot(0.8, 10)
		player.change_circle(0.5, 50,0.3)
		last_pos = 0
		nextMusic = 1
	elif pos < 1800:
		canvas_modulate.color = canvas_modulate.color.linear_interpolate("d3d3d3", delta)
		player.change_spot(0.9,9)
		player.change_circle(0.6,45,0.35)
		last_pos = 1
		nextMusic = 1
	elif pos < 3100:
		canvas_modulate.color = canvas_modulate.color.linear_interpolate("a1a1a1", delta)
		player.change_spot(1.0,8)
		player.change_circle(0.7,40,0.4)
		last_pos = 2
		nextMusic = 2
	elif pos < 4600:
		canvas_modulate.color = canvas_modulate.color.linear_interpolate("858585", delta)
		player.change_spot(1.1,7)
		player.change_circle(0.8,35,0.45)
		last_pos = 3
		nextMusic = 3
	elif pos >= 4600:
		canvas_modulate.color = canvas_modulate.color.linear_interpolate("444444", delta)
		tween.interpolate_property(canvas_modulate, "color", canvas_modulate.color, Color("444444"), 0.5,3,1)
		player.change_spot(1.5,5)
		player.change_circle(0.9,20,0.6)
		last_pos = 4
		nextMusic = 4
	tween.start()

func music_transition(obj: AudioStreamPlayer):
	obj.volume_db = -80
	tween.interpolate_property(obj, "volume_db", -80, Global.music_vol - 30, 2,0,0)
	tween.start()

func won():
	music.stop()
	music2.stop()
	music3.stop()
	music4.stop()
	gamefinished.display()
	hud.visible = false
	Global.settings["skin_crown"] = 1 
	Global.save()
	canvas_modulate.visible = false
	debug_overlay.visible = false
	gamefinished.visible = true

func music_changed():
	if Global.music_on:
		music.volume_db = Global.music_vol - 30
	else:
		music.volume_db = -80

func select_music():
	match nextMusic:
		1:
			music.play()
			music_transition(music)
		2:
			music2.play()
			music_transition(music2)
		3:
			music3.play()
			music_transition(music3)
		4:
			music4.play()
			music_transition(music4)
	transitioning = false

func _on_MusicStreamPlayer_finished() -> void:
	select_music()


func _on_MusicStreamPlayer2_finished() -> void:
	select_music()


func _on_MusicStreamPlayer3_finished() -> void:
	select_music()


func _on_MusicStreamPlayer4_finished() -> void:
	select_music()
