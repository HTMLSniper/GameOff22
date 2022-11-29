extends Sprite

onready var timer = $Timer
onready var anim = $AnimationPlayer

func _ready() -> void:
	timer.wait_time = rand_range(1,3)

func _on_Timer_timeout() -> void:
	timer.wait_time = rand_range(1,3)
	anim.play("pulse")
