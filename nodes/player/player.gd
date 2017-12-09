extends KinematicBody2D

var max_hp = 20
var hp = max_hp
var speed = 300
var inv_time = 1
var inv_frames = 0
var vulnerability_ratio = 8
var enabled = true

var spirit_power = 15
var spirit_power_max = 60
var shot_interval = .5
var cooldown = shot_interval

#movement
var up = 0
var down = 0
var left = 0
var right = 0

# children
var anim
var damage_anim
var level
var level_anim
var sound

# load
var bullet = preload("res://nodes/player/bullet/spirit-missile.tscn")

func _ready():
	add_to_group(global.PLAYER_GROUP)
	anim = get_node("anim")
	damage_anim = get_node("damage-anim")
	sound = get_node("sound")
	level = get_node("../")
	level_anim = level.get_node("level_canvas/level-anim")
	if global.save_hp:
		hp = global.save_hp
	if global.save_power:
		spirit_power = global.save_power
	set_process(true)

func _process(delta):
	if enabled:
		# movement
		if Input.is_action_pressed("move_up"):
			up = -1
		else:
			up = 0
		if Input.is_action_pressed("move_down"):
			down = 1
		else:
			down = 0
		if Input.is_action_pressed("move_left"):
			left = -1
		else:
			left = 0
		if Input.is_action_pressed("move_right"):
			right = 1
		else:
			right = 0
		
		# set animation
		if (up + down) == -1:
			anim.set_current_animation("up")
		elif (up + down) == 1:
			anim.set_current_animation("down")
		if (left + right) == -1:
			anim.set_current_animation("left")
		elif (left + right) == 1:
			anim.set_current_animation("right")
		
		# update position
		move(Vector2(left + right, 0) * speed * delta)
		move(Vector2(0, up + down) * speed * delta)
		
		#update inv frames
		if inv_frames > 0:
			inv_frames -= delta
		
		# update cooldown
		if cooldown > 0:
			cooldown -= delta
		
		# shoot
		if Input.is_action_pressed("shoot") && cooldown <= 0 && spirit_power > 0:
			shoot()
			cooldown = shot_interval

func shoot():
	var dir = get_global_mouse_pos() - get_global_pos()
	dir /= sqrt(dir.dot(dir))
	var new = bullet.instance()
	new.set_global_pos(get_global_pos())
	new.direction = dir
	level.add_child(new)
	spirit_power -= 1
	global.save_power = spirit_power

func gain_spirit_power(value):
	sound.play("powerup")
	spirit_power += value
	if spirit_power > spirit_power_max:
		spirit_power = spirit_power_max
	global.save_power = spirit_power

func take_damage(value):
	if inv_frames <= 0:
		hp -= (value * (spirit_power/vulnerability_ratio + 1))
		if hp <= 0:
			damage_anim.play("damage")
			inv_frames = inv_time
			level_anim.play("game-over")
		else:
			damage_anim.play("damage")
			inv_frames = inv_time
	global.save_hp = hp

func heal(value):
	sound.play("heal")
	hp += value
	if hp > max_hp:
		hp = max_hp
	global.save_hp = hp
