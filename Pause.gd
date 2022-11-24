extends Control


func _ready() -> void:
	visible = false

func _input(event):
	if event.is_action_pressed("pause"):
		var new_pause_state = not get_tree().paused # negate
		get_tree().paused = new_pause_state
		visible = new_pause_state

func _on_Resume_pressed() -> void:
	var new_pause_state = not get_tree().paused # negate
	get_tree().paused = new_pause_state
	visible = new_pause_state

func _on_Menu_pressed() -> void:
	var new_pause_state = not get_tree().paused # negate
	get_tree().paused = new_pause_state
	visible = new_pause_state
	get_tree().change_scene("res://MainMenu.tscn")
