extends Node2D

onready var goal = $Goal
onready var debug_overlay = $DebugOverlay
onready var animation = $AnimationPlayer
onready var hud = $CanvasLayer/HUD
onready var gamefinished = $CanvasLayer/GameFinished
onready var canvas_modulate = $CanvasModulate


func _ready() -> void:
	Global.player.connect("game_won", self, "won")
	Global.load_from_file()
	Global.player.connect_goal()
	Shake.set_cam()
	add_debug_stats()
	Global.player.fadein()

func _process(delta: float) -> void:
	change_color_for_depth(Global.player)

func add_debug_stats():
	debug_overlay.add_stat("FPS", Engine, "get_frames_per_second", true)
	debug_overlay.add_stat("Player position", $Player, "position", false)
	debug_overlay.add_stat("Player state", $Player, "get_state", true)
	debug_overlay.add_stat("Player velocity", $Player, "velocity", false)
	debug_overlay.add_stat("Player jumping", $Player, "is_jumping", false)
	debug_overlay.add_stat("Player jumps made", $Player, "jumps_made", false)
	debug_overlay.add_stat("Player backpack frame", $Player, "get_stats", true)
	debug_overlay.add_stat("Player on floor", $Player, "is_on_floor", true)
	debug_overlay.add_stat("Coins", Global, "coins", false)
	debug_overlay.add_stat("GMin", Global, "timem", false)
	debug_overlay.add_stat("GSec", Global, "times", false)
	debug_overlay.add_stat("Timer Zero", $CanvasLayer/HUD/Timer, "time_zero", false)
	debug_overlay.add_stat("Current Time", Time, "get_time_dict_from_system", true)
	debug_overlay.add_stat("Player Shader", $Player, "get_stats", true)

func change_color_for_depth(player):
	var pos = player.position.y
	if pos < 700:
		canvas_modulate.color = "ffffff"
		player.change_spot(0.8, 10)
		player.change_circle(0.5, 50,0.3)
	elif pos < 1800:
		canvas_modulate.color = "d3d3d3"
		player.change_spot(0.9,9)
		player.change_circle(0.6,45,0.35)
	elif pos < 3100:
		canvas_modulate.color = "a1a1a1"
		player.change_spot(1.0,8)
		player.change_circle(0.7,40,0.4)
	elif pos < 4600:
		canvas_modulate.color = "858585"
		player.change_spot(1.1,7)
		player.change_circle(0.8,35,0.45)
	elif pos >= 4600:
		canvas_modulate.color = "444444"
		player.change_spot(1.5,5)
		player.change_circle(0.9,20,0.6)

func won():
	gamefinished.display()
	hud.visible = false
	canvas_modulate.visible = false
	debug_overlay.visible = false
	gamefinished.visible = true
