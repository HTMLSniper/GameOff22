extends Label

var time_played_last
var time_zero
var time_pauseds = 0
var time_pausedm = 0
var time_pausedh = 0
var time_paused = 0
var time_paused_start
var paused = false


func _ready() -> void:
	time_zero = OS.get_system_time_msecs()
	time_played_last = Global.time_played

func _process(delta: float) -> void:
	if Global.paused and paused:
		# both paused
		# do nothing
		return
	elif Global.paused and not paused:
		# just got paused
		paused = true
		time_paused_start = OS.get_system_time_msecs()
		# last time is saved
		return
	elif not Global.paused and paused:
		# just got unpaused
		time_paused = OS.get_system_time_msecs() - time_paused_start
		paused = false
	elif not Global.paused and not paused:
		pass

	var msecs = time_played_last + OS.get_system_time_msecs() - time_zero - time_paused
	Global.time_played = msecs
	var times = fix_times(int(msecs / 1000))
	var secs = times["second"]
	var mins = times["minute"]
	var hours = times["hour"]
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

func fix_times(secs):
	secs = fmod(secs, (24 * 3600))
	var hours = int(secs / 3600)
	secs = fmod(secs,3600)
	var mins = int(secs / 60)
	secs = fmod(secs, 60)
	var n = {"second": secs, "minute": mins, "hour": hours}
	return n
