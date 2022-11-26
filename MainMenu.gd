extends Node2D

func _ready() -> void:
	$Camera2D.current = true
	Shake.set_cam()


func _on_Play_pressed() -> void:
	get_tree().change_scene("res://World.tscn")


func _on_Options_pressed() -> void:
	pass # Replace with function body.
	# get_tree().change_scene("res://Options.tscn")


func _on_Quit_pressed() -> void:
	get_tree().quit()
