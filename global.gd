extends Node

var ROOM_HEIGHT = 544
var ROOM_WIDTH = 544

var PLAYER_GROUP = "player"
var ENEMY_GROUP = "enemy"
var WALL_GROUP = "wall"

var save_power = 0
var save_hp = 0

var scenes = []
var current_scene = 0

func _ready():
	scenes.append(load("res://scenes/intro.tscn"))
	scenes.append(load("res://scenes/controls.tscn"))
	scenes.append(load("res://scenes/test.tscn"))
	scenes.append(load("res://scenes/level2.tscn"))
	scenes.append(load("res://scenes/credits.tscn"))
	scenes.append(load("res://scenes/game-over.tscn"))

func move_forward_scene():
	change_scene_to(current_scene + 1)

func first_scene():
	change_scene_to(0)
	save_hp = 0
	save_power = 0

func game_over():
	change_scene_to(scenes.size()-1)
	save_hp = 0
	save_power = 0

func change_scene_to(index):
	get_tree().change_scene_to(scenes[index])
	current_scene = index
