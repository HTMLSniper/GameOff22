extends CanvasLayer



func _on_Continue_pressed() -> void:
	get_tree().change_scene("res://World.tscn")


func _on_Restart_pressed() -> void:
	Global.reset_everything()
	Global.save_to_file()
	get_tree().change_scene("res://World.tscn")
