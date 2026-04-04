extends Node


@export var current_map = null
@export var player_position = Vector2(100, 100)
@onready var main_scene = get_tree().get_first_node_in_group("Main_Scene")

func change_current_map(path, limits):
	var map_scene = load(path)
	var map_instance = map_scene.instantiate()
	main_scene.add_child(map_instance)
	current_map = map_instance
