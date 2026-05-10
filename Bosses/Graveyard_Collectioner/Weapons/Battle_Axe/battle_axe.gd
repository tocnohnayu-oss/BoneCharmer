extends Weapon


var angle = 0.0
var radius = 10.0
var initial_speed = 20.0
var SPEED = initial_speed
var ACCELERATION = 5.0
var center:Vector2
var is_ready = true
var duration = 5.0
@onready var battle_axe_projectile_scene = preload("res://Bosses/Graveyard_Collectioner/Weapons/Battle_Axe/Battle_Axe_Projectile/battle_axe_projectile.tscn")

func _ready() -> void:
	super._ready()
	SPEED = 10.0
	ACCELERATION = 0.0
	ability_function = create_battle_axe_projectile
	type = Type.BOSS


func create_battle_axe_projectile(direction:Vector2, target_position:Vector2):
	if not is_ready:
		return
	var axe_projectile = battle_axe_projectile_scene.instantiate()
	set_collisions_to_projectile(axe_projectile)
	axe_projectile.global_position = global_position
	axe_projectile.target_position = target_position
	axe_projectile.kill_position = Vector2.ZERO
	axe_projectile.rotation = rotation
	axe_projectile.projectile_destroy.connect(_on_axe_destroy)
	axe_projectile.damage = damage
	axe_projectile.direction = direction
	axe_projectile.parent_axe = self
	#axe_projectile.type = Type.BOSS
	visible = false
	is_ready = false
	axe_projectile.kill_area = create_kill_area(target_position)
	get_tree().get_first_node_in_group("Main_Scene").add_child(axe_projectile)
	is_ready = false
	get_tree().create_timer(duration).timeout.connect(_on_cooldown_timer_finished)


func _on_cooldown_timer_finished():
	is_ready = true


func _on_axe_destroy():
	visible = true
	is_ready = true
