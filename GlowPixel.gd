extends Sprite

onready var timer = $Timer
onready var anim = $AnimationPlayer

func _ready() -> void:
	randomize()
	timer.wait_time = rand_range(1,15)
	timer.start()

func _on_Timer_timeout() -> void:
	randomize()
	timer.wait_time = rand_range(1,15)
	anim.play("pulse")
	timer.start()
