extends Node2D

onready var goal = $Goal
onready var debug_overlay = $DebugOverlay
onready var animation = $AnimationPlayer
onready var hud = $CanvasLayer/HUD
onready var gamefinished = $CanvasLayer/GameFinished
onready var canvas_modulate = $CanvasModulate

var last_pos = 0


func _ready() -> void:
	Global.player.connect("game_won", self, "won")
	Global.load_from_file()
	Global.player.connect_goal()
	Shake.set_cam()
	#add_debug_stats()
	Global.player.fadein()

func _process(delta: float) -> void:
	change_color_for_depth(Global.player, delta)

func add_debug_stats():
	debug_overlay.add_stat("FPS", Engine, "get_frames_per_second", true)
	debug_overlay.add_stat("Player position", $Player, "position", false)
	debug_overlay.add_stat("Player state", $Player, "get_state", true)
	debug_overlay.add_stat("Player velocity", $Player, "velocity", false)
	debug_overlay.add_stat("Player jumping", $Player, "is_jumping", false)
	debug_overlay.add_stat("Player jumps made", $Player, "jumps_made", false)
	debug_overlay.add_stat("Player jump height", $Player, "jump_height", false)
	debug_overlay.add_stat("Player backpack frame", $Player, "get_stats", true)
	debug_overlay.add_stat("Player on floor", $Player, "is_on_floor", true)
	debug_overlay.add_stat("Coins", Global, "coins", false)
	debug_overlay.add_stat("GMin", Global, "timem", false)
	debug_overlay.add_stat("GSec", Global, "times", false)
	debug_overlay.add_stat("Timer Zero", $CanvasLayer/HUD/Timer, "time_zero", false)
	debug_overlay.add_stat("Current Time", Time, "get_time_dict_from_system", true)
	debug_overlay.add_stat("Player Shader", $Player, "get_stats", true)

func change_color_for_depth(player, delta):
	# not nice but works
#	if last_pos == 0 and pos > 0 and pos < 700:
#		return
#	elif last_pos == 1 and pos > 700 and pos < 1800:
#		return
#	elif last_pos == 2 and pos > 1800 and pos < 3100:
#		return
#	elif last_pos == 3 and pos > 3100 and pos < 4600:
#		return
#	elif last_pos == 4 and pos > 4600:
#		return
	var pos = player.position.y
	var tween = $CanvasModulate/Tween
	if pos < 700:
		#canvas_modulate.color = "ffffff"
		canvas_modulate.color = canvas_modulate.color.linear_interpolate("ffffff", delta)
		#tween.interpolate_property(canvas_modulate, "color", canvas_modulate.color, Color("ffffff"), 0.5,3,1)
		#tween.interpolate_property(canvas_modulate, "color:g", canvas_modulate.color.g, 1, 0.5, 3, 1)
		#tween.interpolate_property(canvas_modulate, "color:b", canvas_modulate.color.b, 1, 0.5, 3, 1)
		tween.start()
		player.change_spot(0.8, 10)
		player.change_circle(0.5, 50,0.3)
		last_pos = 0
	elif pos < 1800:
		#canvas_modulate.color = "d3d3d3"
		canvas_modulate.color = canvas_modulate.color.linear_interpolate("d3d3d3", delta)
		#tween.interpolate_property(canvas_modulate, "color", canvas_modulate.color, Color("d3d3d3"), 0.5,3,1)
		#tween.interpolate_property(canvas_modulate, "color:g", canvas_modulate.color.g, 0.9, 0.5,3,1)
		#tween.interpolate_property(canvas_modulate, "color:b", canvas_modulate.color.b, 0.9, 0.5,3,1)
		tween.start()
		player.change_spot(0.9,9)
		player.change_circle(0.6,45,0.35)
		last_pos = 1
	elif pos < 3100:
		#canvas_modulate.color = "a1a1a1"
		canvas_modulate.color = canvas_modulate.color.linear_interpolate("a1a1a1", delta)
		#tween.interpolate_property(canvas_modulate, "color", canvas_modulate.color, Color("a1a1a1"), 0.5,3,1)
		#tween.interpolate_property(canvas_modulate, "color:g", canvas_modulate.color.g, 0.8, 0.5,3,1)
		#tween.interpolate_property(canvas_modulate, "color:b", canvas_modulate.color.b, 0.8, 0.5,3,1)
		player.change_spot(1.0,8)
		player.change_circle(0.7,40,0.4)
		last_pos = 2
	elif pos < 4600:
		#canvas_modulate.color = "858585"
		canvas_modulate.color = canvas_modulate.color.linear_interpolate("858585", delta)
		#tween.interpolate_property(canvas_modulate, "color", canvas_modulate.color, Color("858585"), 0.5,3,1)
		#tween.interpolate_property(canvas_modulate, "color:g", canvas_modulate.color.g, 0.7, 0.5,3,1)
		#tween.interpolate_property(canvas_modulate, "color:b", canvas_modulate.color.b, 0.7, 0.5,3,1)
		player.change_spot(1.1,7)
		player.change_circle(0.8,35,0.45)
		last_pos = 3
	elif pos >= 4600:
		#canvas_modulate.color = "444444"
		canvas_modulate.color = canvas_modulate.color.linear_interpolate("444444", delta)
		tween.interpolate_property(canvas_modulate, "color", canvas_modulate.color, Color("444444"), 0.5,3,1)
		#tween.interpolate_property(canvas_modulate, "color:g", canvas_modulate.color.g, 0.4, 0.5,3,1)
		#tween.interpolate_property(canvas_modulate, "color:b", canvas_modulate.color.b, 0.4, 0.5,3,1)
		player.change_spot(1.5,5)
		player.change_circle(0.9,20,0.6)
		last_pos = 4

func won():
	gamefinished.display()
	hud.visible = false
	canvas_modulate.visible = false
	debug_overlay.visible = false
	gamefinished.visible = true
