class_name Unit_group
extends Area2D


signal unit_killed()


func _ready() -> void:
	unit_killed.connect(_on_unit_killed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_unit_killed():
	if len(get_children()) <= 2:
		queue_free()
