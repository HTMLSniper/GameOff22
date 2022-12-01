extends Control

onready var click_sound = $AudioStreamPlayer

func _ready() -> void:
	visible = false
	Global.connect("sound_changed_live", self, "sound_changed")
	Global.connect("music_changed_live", self, "music_changed")

func _input(event):
	if event.is_action_pressed("pause"):
		var new_pause_state = not get_tree().paused # negate
		get_tree().paused = new_pause_state
		visible = new_pause_state
		Global.paused = new_pause_state

func music_changed():
	pass

func sound_changed():
	if Global.sound_on:
		click_sound.volume_db = Global.sound_vol
	else:
		click_sound.volume_db = -80

func _on_Resume_pressed() -> void:
	click_sound.pitch_scale = rand_range(0.5,2.5)
	sound_changed()
	click_sound.play()
	var new_pause_state = not get_tree().paused # negate
	get_tree().paused = new_pause_state
	visible = new_pause_state
	Global.paused = new_pause_state

func _on_Menu_pressed() -> void:
	click_sound.pitch_scale = rand_range(0.5,2.5)
	sound_changed()
	click_sound.play()
	Global.save_to_file()
	Global.save()
	var new_pause_state = not get_tree().paused # negate
	get_tree().paused = new_pause_state
	visible = new_pause_state
	Global.paused = new_pause_state
	get_tree().change_scene("res://MainMenu.tscn")
