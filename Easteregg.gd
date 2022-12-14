extends Area2D

onready var animation = $AnimationPlayer
onready var pickup_sound = $AudioStreamPlayer 

export(int) var number = 1

var collected = false

func _ready() -> void:
	Global.connect("sound_changed_live", self, "sound_changed")
	if Global.easteregg:
		queue_free()

func sound_changed():
	if Global.sound_on:
		pickup_sound.volume_db = Global.sound_vol - 15
	else:
		pickup_sound.volume_db = -80

func _on_Easteregg_body_entered(body: Node) -> void:
		if body.has_method("get_coin") and not collected:
			sound_changed()
			collected = true
			pickup_sound.pitch_scale = rand_range(0.8,1.2)
			animation.play("coin_found")
			body.get_coin(5)
			Global.easteregg = true

