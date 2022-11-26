extends Label

var max_reached_height = 0
var max_height


func _ready() -> void:
	max_height = Global.goal.position.y

func _process(delta: float) -> void:
	var playerPos = Global.player.position.y
	#max_height = Global.goal.position.y
	#if Global.player:
	if playerPos < 25:
		return
	if playerPos > max_reached_height:
		max_reached_height = playerPos
		var pos_percentage = clamp(playerPos/(max_height / 100.0),0.00,100.0)
		var percentage = "%3.2f" % [pos_percentage] + "%"
		text = percentage
