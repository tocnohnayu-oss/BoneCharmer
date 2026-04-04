extends Sprite2D


@onready var bullet_scene = preload("res://Player/Weapons/Magic_Staff/Bullet.tscn")
@export var damage = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func create_bullet(direction: Vector2, target_position: Vector2) -> void:
	var bullet = bullet_scene.instantiate()
	bullet.direction = direction
	bullet.damage = damage
	bullet.scale = Vector2(0.4, 0.4)
	bullet.global_position = global_position
	bullet.look_at(target_position)
	bullet.kill_position = target_position
	get_tree().get_first_node_in_group("Main_Scene").add_child(bullet)
