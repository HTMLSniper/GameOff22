extends Sprite

func _ready() -> void:
	var tween = $Tween
	tween.interpolate_property(self, "modulate:a", 0.5,0.0,0.5,3,1)
	tween.start()

func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	queue_free()
