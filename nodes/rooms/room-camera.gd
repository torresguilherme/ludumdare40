extends Camera2D

var rot_speed = 0
var shake_instensity = .12
var rot_dir = 1

func _ready():
	set_process(true)

func _process(delta):
	if rot_speed > 0:
		rot_speed -= delta
	elif rot_speed < 0:
		rot_speed = 0
	
	if rot_speed == 0:
		set_rot(0)
	else:
		rotate(rot_dir * rot_speed)
		rot_dir *= -1

func screen_shake():
	rot_speed = shake_instensity
