extends CanvasLayer

onready var click_sound = $AudioStreamPlayer

var start = true


func _ready() -> void:
	Global.load()
	$MusicSlider.value = Global.music_vol
	$SoundSlider.value = Global.sound_vol
	$CheckBox.pressed = Global.cheats_active
	offset.y = 0
	start = false

func sound_changed():
	if Global.sound_on:
		click_sound.volume_db = Global.sound_vol
	else:
		click_sound.volume_db = -80

func _on_MusicSlider_value_changed(value: float) -> void:
	Global.change_music(value)
	if start: 
		return
	click_sound.pitch_scale = rand_range(0.5,2.5)
	sound_changed()
	click_sound.play()


func _on_SoundSlider_value_changed(value: float) -> void:
	Global.change_sound(value)
	if start: 
		return
	click_sound.pitch_scale = rand_range(0.5,2.5)
	sound_changed()
	click_sound.play()


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


func _on_CheckBox_pressed() -> void:
	Global.cheats_active = not Global.cheats_active
	if start: 
		return
	click_sound.pitch_scale = rand_range(0.5,2.5)
	sound_changed()
	click_sound.play()
