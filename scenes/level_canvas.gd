extends CanvasLayer

func _ready():
	pass

func next_scene():
	global.move_forward_scene()

func game_over():
	global.game_over()