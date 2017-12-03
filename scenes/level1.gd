extends Node2D

var level_dimension = 20
var number_of_rooms = level_dimension/2
var level_matrix = []

var initial_room = preload("res://nodes/rooms/initial-room.tscn")
var final_room = preload("res://nodes/rooms/final-room.tscn")
var rooms = []
var door = preload("res://nodes/scenario/chains.tscn")
var not_door = preload("res://nodes/scenario/non-chain.tscn")

var player

func _ready():
	randomize()
	player = get_node("player")
	rooms.append(load("res://nodes/rooms/room0.tscn"))
	rooms.append(load("res://nodes/rooms/room1.tscn"))
	rooms.append(load("res://nodes/rooms/room2.tscn"))
	rooms.append(load("res://nodes/rooms/room3.tscn"))
	generate_rooms()

func generate_rooms():
	# usar com as posicoes no vetor de nodes na seguinte ordem:
	# norte/leste/sul/oeste
	var room_list = []
	for i in range(level_dimension):
		var new = []
		for j in range(level_dimension):
			new.append(0)
		level_matrix.append(new)
	var pos = [level_dimension/2, level_dimension/2]
	var rooms_left = number_of_rooms
	var modifiers = [-1, 1]
	while(rooms_left):
		if level_matrix[pos[0]][pos[1]] == 0:
			level_matrix[pos[0]][pos[1]] = 1
			rooms_left -= 1
			var new_room
			if rooms_left == number_of_rooms - 1:
				new_room = initial_room.instance()
			elif rooms_left == 1:
				new_room = final_room.instance()
			else:
				new_room = rooms[randi()% rooms.size()].instance()
			new_room.set_global_pos(Vector2(pos[0] * global.ROOM_WIDTH, pos[1] * global.ROOM_HEIGHT))
			add_child(new_room)
			room_list.append(new_room)
		var temp = randi()%2
		var temp2 = modifiers[randi() % modifiers.size()]
		pos[temp] += temp2
	# adiciona portas
	for it in room_list:
		var it_positions = it.get_node("positions")
		var it_doors = it.get_node("doors")
		var it_walls = it.get_node("walls")
		if (it.get_global_pos().y != 0) && (level_matrix[it.get_global_pos().x/global.ROOM_WIDTH][it.get_global_pos().y/global.ROOM_HEIGHT - 1] == 1):
			it.open_directions[0] = true
		else:
			var new = not_door.instance()
			new.set_global_pos(it_positions.get_children()[0].get_pos())
			it_walls.add_child(new)
		if (it.get_global_pos().x != (level_dimension-1) * global.ROOM_WIDTH) && (level_matrix[it.get_global_pos().x/global.ROOM_WIDTH + 1][it.get_global_pos().y/global.ROOM_HEIGHT] == 1):
			it.open_directions[1] = true
		else:
			var new = not_door.instance()
			new.set_global_pos(it_positions.get_children()[1].get_pos())
			new.set_rot(deg2rad(90))
			it_walls.add_child(new)
		if (it.get_global_pos().y != (level_dimension-1) * global.ROOM_HEIGHT) && (level_matrix[it.get_global_pos().x/global.ROOM_WIDTH][it.get_global_pos().y/global.ROOM_HEIGHT + 1] == 1):
			it.open_directions[2] = true
		else:
			var new = not_door.instance()
			new.set_global_pos(it_positions.get_children()[2].get_pos())
			it_walls.add_child(new)
		if (it.get_global_pos().x != 0) && (level_matrix[it.get_global_pos().x/global.ROOM_WIDTH - 1][it.get_global_pos().y/global.ROOM_HEIGHT] == 1):
			it.open_directions[3] = true
		else:
			var new = not_door.instance()
			new.set_global_pos(it_positions.get_children()[3].get_pos())
			new.set_rot(deg2rad(90))
			it_walls.add_child(new)
	player.set_global_pos(Vector2(level_dimension/2 * global.ROOM_WIDTH, level_dimension/2 * global.ROOM_HEIGHT))