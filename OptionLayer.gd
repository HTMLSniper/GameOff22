extends CanvasLayer

onready var click_sound = $AudioStreamPlayer


func _ready() -> void:
	Global.load()
	$MusicSlider.value = Global.music_vol
	$SoundSlider.value = Global.sound_vol
	offset.y = 0

func _on_MusicSlider_value_changed(value: float) -> void:
	Global.change_music(value)


func _on_SoundSlider_value_changed(value: float) -> void:
	Global.change_sound(value)


func _on_Back_pressed() -> void:
	Global.save()
	click_sound.pitch_scale = rand_range(0.5,2.5)
	sound_changed()
	click_sound.play()
	var tween = $Tween
	tween.interpolate_property(self, "scale:y", 1.0,0.0,0.5,3,1)
	tween.interpolate_property(self, "offset:y", 0.0,100.0,0.5,3,1)
	tween.start()
	#visible = false

func sound_changed():
	if Global.sound_on:
		click_sound.volume_db = Global.sound_vol
	else:
		click_sound.volume_db = -80
