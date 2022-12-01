extends Area2D

onready var animation = $AnimationPlayer
onready var pickup_sound = $AudioStreamPlayer 

export(int) var number = 1

var collected = false

func _ready() -> void:
	Global.connect("sound_changed_live", self, "sound_changed")
	if number >= len(Global.coins):
		Global.coins.append(collected)
	if Global.coins[number]:
		queue_free()

func _on_Coin_body_entered(body: Node) -> void:
	if body.has_method("get_coin"):
		pickup_sound.pitch_scale = rand_range(0.8,1.2)
		animation.play("coin_found")
		body.get_coin()
		Global.coins[number] = true

func sound_changed():
	if Global.sound_on:
		pickup_sound.volume_db = Global.sound_volume - 15
	else:
		pickup_sound.volume_db = -80
