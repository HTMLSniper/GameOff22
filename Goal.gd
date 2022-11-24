extends Node2D

signal game_won

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		emit_signal("game_won")
