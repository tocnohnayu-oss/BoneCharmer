extends Weapon


@onready var minion_scene = preload("res://Units/Minion/Minion.tscn")
@onready var summoning_portal_sprite = preload("res://Resources/sprite_frames/summoning_portal.tres")
var spawn_range = 50.0
var minions: Array
var minion_limit = 5


func _ready() -> void:
	super._ready()
	cooldown = 1.0
	ability_function = summon_minion
	damage = 15.0


func summon_minion(direction: Vector2, target_position: Vector2):
	update_minions()
	if len(minions) >= minion_limit:
		return
	var minion = minion_scene.instantiate()
	var minion_position = global_position + direction * spawn_range
	minion.type = type
	minion.set_collision_layer_value(1, type == Type.ALLY)
	minion.set_collision_layer_value(2, type == Type.ENEMY)
	var summoning_portal = AnimatedSprite2D.new()
	summoning_portal.sprite_frames = summoning_portal_sprite
	add_child(summoning_portal)
	summoning_portal.play("summon")
	await summoning_portal.animation_finished
	summoning_portal.queue_free()
	var parent = get_tree().get_first_node_in_group("Main_Scene")
	if type == Type.ENEMY:
		parent = get_parent().get_parent()
	parent.add_child(minion)
	minion.global_position = minion_position
	minions.append(minion)


func update_minions():
	minions = minions.filter(func (minion): is_instance_valid(minion))
