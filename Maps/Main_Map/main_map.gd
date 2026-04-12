extends Node2D


@onready var skeleton_scene = preload("res://Units/Skeleton/Skeleton.tscn")
@onready var skeleton_archer_scene = preload("res://Units/Skeleton_Archer/Skeleton_archer.tscn")
@onready var wizard_summoner_scene = preload("res://Units/Wizard_Summoner/Wizard_Summoner.tscn")
@onready var group_scene = preload("res://Group/Group.tscn")


func _ready() -> void:
	for i in range(10):
		spawn_group()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_unit(position, group):
	var unit_class_random = randf()
	var unit = null
	if unit_class_random >= 0.6:
		unit = skeleton_archer_scene.instantiate()
	elif unit_class_random >= 0.2:
		unit = skeleton_scene.instantiate()
	else:
		unit = wizard_summoner_scene.instantiate()
	unit.type = unit.Type.ENEMY
	unit.collision_layer = 2
	group.add_child(unit)
	unit.position = position

func _on_spawn_timer_timeout() -> void:
	spawn_group()


func spawn_group():
	var group = group_scene.instantiate()
	var size = group.get_child(0).shape.size
	var group_position = Vector2(randf_range(0.0, Globals.current_map_limits.x - 100.0), randf_range(0.0, Globals.current_map_limits.y - 100.0)) + global_position
	group.global_position = group_position
	add_child(group)
	for i in range(randi_range(1, 5)):
		var offset = Vector2(randf_range(1, size.x - 1), randf_range(1, size.y - 1))
		var skeleton_position = offset
		spawn_unit(skeleton_position, group)
