extends Area2D

onready var player = get_node("../../player")
onready var level_anim = get_node("../../level_canvas/level-anim")

func _ready():
	pass


func _on_portal_body_enter( body ):
	if body.is_in_group(global.PLAYER_GROUP):
		player.enabled = false
		level_anim.play("next")
