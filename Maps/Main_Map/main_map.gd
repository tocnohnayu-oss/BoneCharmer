extends Node2D


@onready var skeleton_scene = preload("res://Units/Skeleton/Skeleton.tscn")


func _ready() -> void:
	for i in range(10):
		var skeleton_position = Vector2(randf_range(0.0, Globals.current_map_limits.x), randf_range(0.0, Globals.current_map_limits.y)) + global_position
		spawn_skeleton(skeleton_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_skeleton(position):
	var skeleton = skeleton_scene.instantiate()
	skeleton.global_position = position
	skeleton.type = skeleton.Type.ENEMY
	skeleton.collision_layer = 2
	add_child(skeleton)

func _on_spawn_timer_timeout() -> void:
	var skeleton_position = Vector2(randf_range(0.0, Globals.current_map_limits.x), randf_range(0.0, Globals.current_map_limits.y)) + global_position
	spawn_skeleton(skeleton_position)
