extends Node2D


@onready var player_scene = preload("res://Player/Player.tscn")


func _ready() -> void:
	Globals.change_current_map("res://Maps/Main_Map/Main_Map.tscn", Vector2(1152, 640))
	var player = player_scene.instantiate()
	self.add_child(player)
	player.position = Globals.player_position


func _process(delta: float) -> void:
	pass
