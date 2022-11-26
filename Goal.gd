extends Node2D

signal goal_entered

func _ready() -> void:
	Global.reg_goal(self)

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		emit_signal("goal_entered")
