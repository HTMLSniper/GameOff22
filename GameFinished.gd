extends Control

onready var time = $Time
onready var jumps = $Jumps
onready var falls = $Falls

func display():
	var time_text = "Time: %02dH %02dM %02dS" % [Global.timeh,Global.timem,Global.times]
	time.text = time_text
	jumps.text = "Jumps: %5d" % [Global.jumps]
	falls.text = "Falls: %5d" % [Global.falls]
	visible = true

func _on_Menu_pressed() -> void:
	get_tree().change_scene("res://MainMenu.tscn")
