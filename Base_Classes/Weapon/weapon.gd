class_name Weapon
extends AnimatedSprite2D


@onready var bullet_scene = preload("res://Player/Weapons/Magic_Staff/Bullet.tscn")
@export var damage = 10.0
enum Type {
	ALLY,
	ENEMY
}
var type = Type.ALLY
var ability_function
var cooldown = 0.5
var debug_cooldown = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ability_function = create_bullet
	if OS.is_debug_build():
		cooldown = debug_cooldown


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func create_bullet(direction: Vector2, target_position: Vector2) -> void:
	var bullet = bullet_scene.instantiate()
	bullet.type = type
	bullet.set_collision_layer_value(1, type == Type.ALLY)
	bullet.set_collision_layer_value(2, type == Type.ENEMY)
	bullet.direction = direction
	bullet.damage = damage
	bullet.scale = Vector2(0.4, 0.4)
	bullet.global_position = global_position
	bullet.look_at(target_position)
	bullet.kill_position = target_position
	get_tree().get_first_node_in_group("Main_Scene").add_child(bullet)


func use_ability(direction: Vector2, target_position: Vector2):
	ability_function.call(direction, target_position)
