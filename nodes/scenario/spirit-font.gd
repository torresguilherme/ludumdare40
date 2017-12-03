extends Area2D

var value = 10

func _ready():
	pass

func _on_spiritfont_body_enter( body ):
	if body.is_in_group(global.PLAYER_GROUP):
		body.gain_spirit_power(value)
		queue_free()
