extends Node2D

# children
var player
var camera
var doors
var positions
var open_directions = [false, false, false, false]
var enemies
var loot

var must_be_deactivated = false
var chains = preload("res://nodes/scenario/chains.tscn")

func _ready():
	player = get_node("../player")
	camera = get_node("Camera2D")
	doors = get_node("doors")
	enemies = get_node("enemies")
	positions = get_node("positions")
	loot = get_node("loot")
	set_process(true)

func _process(delta):
	# atualiza a camera sendo usada
	if get_pos().distance_to(player.get_global_pos()) < global.ROOM_HEIGHT/2 - 32:
		camera.make_current()
		if enemies.get_children().size() > 0 && !must_be_deactivated:
			activate()
	if get_pos().distance_to(player.get_global_pos()) > global.ROOM_HEIGHT/2 + 32:
		if loot.get_child_count() > 0:
			for i in loot.get_children():
				i.queue_free()
	if (enemies.get_children().size() == 0) && (doors.get_child_count() > 0) && must_be_deactivated:
		deactivate()
		must_be_deactivated = false

func activate():
	for i in range(open_directions.size()):
		if (open_directions[i]):
			var new = chains.instance()
			new.set_pos(positions.get_children()[i].get_pos())
			new.set_rot(deg2rad(90 * i))
			doors.add_child(new)
	for i in enemies.get_children():
		i.set_process(true)
	must_be_deactivated = true

func deactivate():
	for i in doors.get_children():
		i.get_node("anim").play("destroy")
	camera.screen_shake()
