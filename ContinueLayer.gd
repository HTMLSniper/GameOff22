extends CanvasLayer

onready var click_sound = $AudioStreamPlayer

func _ready() -> void:
	Global.connect("sound_changed_live", self, "sound_changed")
	Global.connect("music_changed_live", self, "music_changed")

func music_changed():
	pass

func sound_changed():
	if Global.sound_on:
		click_sound.volume_db = Global.sound_vol
	else:
		click_sound.volume_db = -80

func _on_Continue_pressed() -> void:
	click_sound.pitch_scale = rand_range(0.5,2.5)
	sound_changed()
	click_sound.play()
	get_tree().change_scene("res://World.tscn")


func _on_Restart_pressed() -> void:
	click_sound.pitch_scale = rand_range(0.5,2.5)
	sound_changed()
	click_sound.play()
	Global.reset_everything()
	Global.save_to_file()
	get_tree().change_scene("res://World.tscn")
