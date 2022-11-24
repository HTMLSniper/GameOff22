extends Node

var camera_shake_intensity = 0.2
var camera_shake_duration = 0.1
var camera_shake_intensity_first = 0.4
var camera_shake_duration_first = 0.1
var camera = Camera2D.new()
var shake = false

var noise : OpenSimplexNoise

func _ready() -> void:
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20
	noise.persistence = 0.8

func shake():
	camera_shake_intensity = camera_shake_intensity_first
	camera_shake_duration = camera_shake_duration_first
	shake = true

func set_cam():
	camera = get_tree().current_scene.get_node("Player/Camera2D")
	
func _process(delta: float) -> void:
	if shake:
		if camera_shake_duration <= 0:
			camera.offset = Vector2.ZERO
			camera_shake_intensity = 0.0
			camera_shake_duration = 0.0
			shake = false
			return
			
		camera_shake_duration = camera_shake_duration - delta
		var offset = Vector2.ZERO
		var noise_value_x = noise.get_noise_1d(OS.get_ticks_msec() * 0.1)
		var noise_value_y = noise.get_noise_1d(OS.get_ticks_msec() * 0.1 + 100.0)
		offset = Vector2(noise_value_x, noise_value_y) * camera_shake_intensity * 2.0
		if camera:
			camera.offset = offset
