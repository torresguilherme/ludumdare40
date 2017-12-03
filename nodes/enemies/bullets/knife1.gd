extends Area2D

var damage = 1
var direction = Vector2(0, 0)
var speed
var active = true

var anim
onready var sound = get_node("sound")

func _ready():
	look_at(get_global_pos() - direction)
	anim = get_node("anim")
	sound.play("knife-shot")
	set_process(true)

func _process(delta):
	# update position
	set_global_pos(get_global_pos() + (direction * speed * delta))

func _on_knife1_body_enter( body ):
	if active:
		if body.is_in_group(global.PLAYER_GROUP):
			body.take_damage(damage)
			speed = 0
			anim.play("hit")
			active = false
		elif !body.is_in_group(global.ENEMY_GROUP):
			speed = 0
			anim.play("normal")
			sound.play("knife-cancel")
			active = false
