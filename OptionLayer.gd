extends CanvasLayer


func _ready() -> void:
	$MusicSlider.value = Global.music_vol
	$SoundSlider.value = Global.sound_vol
	offset.y = 0

func _on_MusicSlider_value_changed(value: float) -> void:
	Global.change_music(value)


func _on_SoundSlider_value_changed(value: float) -> void:
	Global.change_sound(value)


func _on_Back_pressed() -> void:
	var tween = $Tween
	tween.interpolate_property(self, "scale:y", 1.0,0.0,0.5,3,1)
	tween.interpolate_property(self, "offset:y", 0.0,100.0,0.5,3,1)
	tween.start()
	#visible = false

