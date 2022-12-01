extends Node2D

func _ready() -> void:
	$Camera2D.current = true
	Shake.set_cam()
	Global.load()


func _on_Play_pressed() -> void:
	var temp_pos = Global.player.position
	Global.load_from_file()
	Global.player.position = temp_pos
	if Global.time_played > 0:
		$ContinueLayer.visible = true
	else:
		get_tree().change_scene("res://World.tscn")


func _on_Options_pressed() -> void:
	$OptionLayer.visible = true
	var tween = $OptionLayer/Tween
	tween.interpolate_property($OptionLayer, "scale:y", 0.0,1.0,0.5,3,1)
	tween.interpolate_property($OptionLayer, "offset:y", 100.0,0.0,0.5,3,1)
	tween.start()

func _on_Quit_pressed() -> void:
	get_tree().quit()

func music_changed():
	pass


func _on_Shop_pressed():
	get_tree().change_scene("res://Shop.tscn")
