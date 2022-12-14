extends CanvasLayer

onready var label = $Label
var stats = []

func add_stat(name, object, ref, is_method):
	stats.append([name, object, ref, is_method])

func _process(delta: float) -> void:
	var label_text = ""
	
	for s in stats:
		var value = null
		if s[1] and weakref(s[1]).get_ref():
			if s[3]:
				value = s[1].call(s[2])
			else:
				value = s[1].get(s[2])
		label_text += str(s[0], ": ", value)
		label_text += "\n"
	
	label.text = label_text
