extends Node2D

onready var goal = $Goal
onready var debug_overlay = $DebugOverlay


func _ready() -> void:
	goal.connect("game_won", self, "won")
	Shake.set_cam()
	add_debug_stats()
	

func add_debug_stats():
	debug_overlay.add_stat("FPS", Engine, "get_frames_per_second", true)
	debug_overlay.add_stat("Player position", $Player, "position", false)
	debug_overlay.add_stat("Timer Zero", $CanvasLayer/HUD/Timer, "time_zero", false)
	debug_overlay.add_stat("Current Time", Time, "get_time_dict_from_system", true)
	debug_overlay.add_stat("Player Shader", $Player, "get_stats", true)

func won():
	get_tree().change_scene("res://MainMenu.tscn")
