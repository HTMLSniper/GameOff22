extends Area2D

onready var animation = $AnimationPlayer

export(int) var number = 1

var collected = false

func _ready() -> void:
	if number > len(Global.coins):
		Global.coins.append(collected)
	if Global.coins[number]:
		visible = false

func _on_Coin_body_entered(body: Node) -> void:
	if body.has_method("get_coin"):
		body.get_coin()
		Global.coins[number] = true
		queue_free()
