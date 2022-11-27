extends Node2D

func _ready() -> void:
	$Camera2D.current = true
	Shake.set_cam()


func _on_Play_pressed() -> void:
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
