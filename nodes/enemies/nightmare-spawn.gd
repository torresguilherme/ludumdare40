extends KinematicBody2D

var hp = 6
var speed = 60
var enabled = true

var shot_interval = 1.5
var cooldown = 0
var direction
var shot_speeds = [350, 300, 250]

#onready
var player
var anim
var damage_anim
var s_points
var room

# loads
var bullet1 = preload("res://nodes/enemies/bullets/knife1.tscn")

func _ready():
	add_to_group(global.ENEMY_GROUP)
	player = get_node("../../../player")
	anim = get_node("anim")
	damage_anim = get_node("damage-anim")
	s_points = get_node("s-points")
	room = get_node("../../")
	cooldown = shot_interval

func _process(delta):
	if enabled:
		# update cooldown
		if cooldown > 0:
			cooldown -= delta
		# movement
		direction = player.get_global_pos() - get_global_pos()
		direction /= sqrt(direction.dot(direction))
		move(direction * speed * delta)
		
		#update animation
		if direction.x > 0:
			if anim.get_current_animation() != "right":
				anim.set_current_animation("right")
		else:
			if anim.get_current_animation() != "left":
				anim.set_current_animation("left")
		
		# shoot
		if cooldown <= 0:
			shoot1(direction)
			cooldown = shot_interval

func shoot1(direction):
	s_points.set_rot(get_angle_to(get_global_pos() - direction))
	var new = []
	for i in range(shot_speeds.size()):
		new.append(bullet1.instance())
		new[i].set_global_pos(get_pos())
		new[i].direction = direction
		new[i].speed = shot_speeds[i]
		room.add_child(new[i])

func take_damage(value):
	if enabled:
		hp -= value
		if hp <= 0:
			damage_anim.play("death")
			enabled = false
		else:
			damage_anim.play("damage")

func drop_spirit_power():
	var spirit_font = load("res://nodes/scenario/spirit-font.tscn")
	var new = spirit_font.instance()
	new.set_global_pos(get_pos())
	room.get_node("loot").add_child(new)
