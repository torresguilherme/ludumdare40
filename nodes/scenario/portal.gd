extends Area2D

onready var level_anim = get_node("../../level_canvas/level-anim")

func _ready():
	pass


func _on_portal_body_enter( body ):
	if body.is_in_group(global.PLAYER_GROUP):
		level_anim.play("next")
