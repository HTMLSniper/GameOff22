extends Node2D

onready var goal = $Goal
onready var debug_overlay = $DebugOverlay
onready var animation = $AnimationPlayer
onready var hud = $CanvasLayer/HUD
onready var gamefinished = $CanvasLayer/GameFinished
onready var canvas_modulate = $CanvasModulate


func _ready() -> void:
	Global.player.connect("game_won", self, "won")
	Global.player.connect_goal()
	Shake.set_cam()
	add_debug_stats()
	Global.player.fadein()

func add_debug_stats():
	debug_overlay.add_stat("FPS", Engine, "get_frames_per_second", true)
	debug_overlay.add_stat("Player position", $Player, "position", false)
	debug_overlay.add_stat("Player state", $Player, "get_state", true)
	debug_overlay.add_stat("Player velocity", $Player, "velocity", false)
	debug_overlay.add_stat("Player jumps made", $Player, "jumps_made", false)
	debug_overlay.add_stat("Player backpack frame", $Player, "get_stats", true)
	debug_overlay.add_stat("Player on floor", $Player, "is_on_floor", true)
	debug_overlay.add_stat("Coins", Global, "coins", false)
	debug_overlay.add_stat("Timer Zero", $CanvasLayer/HUD/Timer, "time_zero", false)
	debug_overlay.add_stat("Current Time", Time, "get_time_dict_from_system", true)
	debug_overlay.add_stat("Player Shader", $Player, "get_stats", true)

func won():
	gamefinished.display()
	hud.visible = false
	canvas_modulate.visible = false
	debug_overlay.visible = false
	gamefinished.visible = true
