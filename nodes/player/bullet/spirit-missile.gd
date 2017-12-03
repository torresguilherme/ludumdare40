extends Area2D

var speed = 500
var damage = 1
var rot_speed = 6
var direction = Vector2(0, 0)
var active = true

onready var anim = get_node("anim")
onready var sound = get_node("sound")

func _ready():
	sound.play("player-shot")
	set_process(true)

func _process(delta):
	set_global_pos(get_global_pos() + (speed * direction * delta))
	rotate(rot_speed)

func _on_spiritmissile_body_enter( body ):
	if active:
		if body.is_in_group(global.ENEMY_GROUP):
			body.take_damage(damage)
			active = false
			speed = 0
			anim.play("destroy")
			sound.play("player-shot-cancel")
		elif !body.is_in_group(global.PLAYER_GROUP):
			active = false
			speed = 0
			anim.play("destroy")