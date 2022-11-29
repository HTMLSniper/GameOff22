extends Area2D

onready var animation = $AnimationPlayer

#func _ready() -> void:
	#animation.play("idle")

func _on_Coin_body_entered(body: Node) -> void:
	if body.has_method("get_coin"):
		body.get_coin()
		queue_free()
