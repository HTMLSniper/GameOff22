extends Label

var time_zero


func _ready() -> void:
	time_zero = Time.get_time_dict_from_system()

func _process(delta: float) -> void:
	var secs = Time.get_time_dict_from_system()["second"] - time_zero["second"] #fmod(time, 60)
	var mins = Time.get_time_dict_from_system()["minute"] - time_zero["minute"] #fmod(time, 60*60)/60
	var hours = Time.get_time_dict_from_system()["hour"] - time_zero["hour"] #fmod(fmod(time, 3600*60)/3600,24)
	if secs < 0:
		secs = 60 + secs
	if mins < 0:
		mins = 60 + mins
	if hours < 0:
		hours = 24 + hours
	var time_passed = "%02d:%02d:%02d" % [hours,mins,secs]
	Global.timeh = hours
	Global.timem = mins
	Global.times = secs
	text = time_passed
