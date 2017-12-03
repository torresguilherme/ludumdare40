extends KinematicBody2D

var speed = 180
var hp = 4
var enabled = true

var player
var anim
var damage_anim
var camera
var room

func _ready():
	randomize()
	add_to_group(global.ENEMY_GROUP)
	player = get_node("../../../player")
	anim = get_node("anim")
	damage_anim = get_node("damage-anim")
	camera = get_node("../../Camera2D")
	room = get_node("../../")

func _process(delta):
	if enabled:
		var direction = player.get_global_pos() - get_global_pos()
		direction /= sqrt(direction.dot(direction))
		move(direction * speed * delta)
		
		#update animation
		if direction.x > 0:
			if anim.get_current_animation() != "right":
				anim.set_current_animation("right")
		else:
			if anim.get_current_animation() != "left":
				anim.set_current_animation("left")

func take_damage(value):
	hp -= value
	if hp <= 0:
		enabled = false
		camera.screen_shake()
		if randi() % 2 == 0:
			drop_spirit_power()
		else:
			drop_heal()
		damage_anim.play("death")

	else:
		damage_anim.play("damage")

func drop_spirit_power():
	var spirit_font = load("res://nodes/scenario/spirit-font.tscn")
	var new = spirit_font.instance()
	new.set_global_pos(get_pos())
	room.get_node("loot").add_child(new)

func drop_heal():
	var spirit_font = load("res://nodes/scenario/heal.tscn")
	var new = spirit_font.instance()
	new.set_global_pos(get_pos())
	room.get_node("loot").add_child(new)
