extends Node2D

onready var click_sound = $AudioStreamPlayer

func _ready() -> void:
	$Camera2D.current = true
	Shake.set_cam()
	Global.load()
	Global.connect("sound_changed_live", self, "sound_changed")
	Global.connect("music_changed_live", self, "music_changed")


func _on_Play_pressed() -> void:
	click_sound.pitch_scale = rand_range(0.5,2.5)
	sound_changed()
	click_sound.play()
	var temp_pos = Global.player.position
	Global.load_from_file()
	Global.player.position = temp_pos
	if Global.time_played > 0:
		$ContinueLayer.visible = true
	else:
		get_tree().change_scene("res://World.tscn")


func _on_Options_pressed() -> void:
	click_sound.pitch_scale = rand_range(0.5,2.5)
	sound_changed()
	click_sound.play()
	$OptionLayer.visible = true
	var tween = $OptionLayer/Tween
	tween.interpolate_property($OptionLayer, "scale:y", 0.0,1.0,0.5,3,1)
	tween.interpolate_property($OptionLayer, "offset:y", 100.0,0.0,0.5,3,1)
	tween.start()

func _on_Quit_pressed() -> void:
	click_sound.pitch_scale = rand_range(0.5,2.5)
	sound_changed()
	click_sound.play()
	get_tree().quit()

func music_changed():
	pass

func sound_changed():
	if Global.sound_on:
		click_sound.volume_db = Global.sound_vol
	else:
		click_sound.volume_db = -80

func _on_Shop_pressed():
	click_sound.pitch_scale = rand_range(0.5,2.5)
	click_sound.play()
	get_tree().change_scene("res://Shop.tscn")
