class_name Weapon
extends AnimatedSprite2D


@onready var bullet_scene = preload("res://Player/Weapons/Magic_Staff/Bullet.tscn")
@onready var audio_player = $AudioPlayer
var main_scene
@export var damage = 10.0
enum Type {
	ALLY,
	ENEMY,
	BOSS
}
var type = Type.ALLY
var ability_function
var is_using = false
var cooldown = 0.5
var debug_cooldown = 0.5
var ally_types = []
var enemy_types = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_scene = get_tree().get_first_node_in_group("Main_Scene")
	ability_function = create_bullet
	if OS.is_debug_build():
		cooldown = debug_cooldown
	update_collisions()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func create_bullet(direction: Vector2, target_position: Vector2) -> void:
	var bullet = bullet_scene.instantiate()
	bullet.type = type
	set_collisions_to_projectile(bullet)
	var bullet_direction = global_position.direction_to(target_position)
	bullet.direction = bullet_direction
	bullet.damage = damage
	bullet.scale = Vector2(0.4, 0.4)
	bullet.global_position = global_position
	bullet.look_at(target_position)
	bullet.kill_position = target_position
	bullet.kill_area = create_kill_area(target_position)
	main_scene.add_child(bullet)


func create_kill_area(target_position: Vector2):
	var kill_area: Area2D = Area2D.new()
	var direction = global_position.direction_to(target_position)
	for enemy_type in enemy_types:
		kill_area.set_collision_layer_value(enemy_type, true)
		kill_area.set_collision_mask_value(enemy_type, true)
	var ka_collision = CollisionShape2D.new()
	ka_collision.shape = CircleShape2D.new()
	ka_collision.shape.set_deferred("radius", 8.0)
	kill_area.global_position = target_position  + direction * ka_collision.shape.radius
	kill_area.add_child(ka_collision)
	main_scene.add_child(kill_area)
	return kill_area


func use_ability(direction: Vector2, target_position: Vector2):
	ability_function.call(direction, target_position)


func set_collisions_to_projectile(projectile: Projectile):
	for ally_type in ally_types:
		projectile.set_collision_layer_value(ally_type, true)
	for enemy_type in enemy_types:
		projectile.set_collision_mask_value(enemy_type, true)


func update_collisions():
	ally_types.clear()
	enemy_types.clear()
	var layers = {
		Type.ALLY: 1,
		Type.ENEMY: 2,
	}
	ally_types.append(layers[Type.ENEMY] if type in [Type.ENEMY, Type.BOSS] else layers[Type.ALLY])
	enemy_types.append(layers[Type.ALLY] if type in [Type.ENEMY, Type.BOSS] else layers[Type.ENEMY])
