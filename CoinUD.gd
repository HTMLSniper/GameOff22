extends Label


func _ready() -> void:
	text = String(Global.settings["coins"])
	Global.connect("coins_changed_live", self, "coins_changed")

func coins_changed():
	text = String(Global.settings["coins"])
