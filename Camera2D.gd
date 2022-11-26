extends Camera2D

const dead_Zone = 300
const smooth_lean := 10.0
const scale_lean := 0.1
var player

func _process(delta: float) -> void:
	if Global.player:
		player = Global.player
		lean_cam_to_mouse(delta)

func lean_cam_to_mouse(delta):
	var mouse_pos = get_global_mouse_position()
	var direction_to_mouse = (mouse_pos - player.position).normalized() 
	var distance_to_mouse = player.position.distance_to(mouse_pos)
	var lean = direction_to_mouse * distance_to_mouse * scale_lean
	if player.position.y < 200:
		lean = Vector2.ZERO
	lean.x = 0
	offset = lerp(offset, lean, delta * smooth_lean)

