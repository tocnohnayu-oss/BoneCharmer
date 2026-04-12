extends Weapon


@onready var minion_scene = preload("res://Units/Minion/Minion.tscn")
@onready var summoning_portal_sprite = preload("res://Resources/sprite_frames/summoning_portal.tres")
@onready var minions = $"../Minions"
var spawn_range = 50.0
var minion_limit = 5


func _ready() -> void:
	super._ready()
	cooldown = 1.0
	ability_function = summon_minion
	damage = 15.0


func summon_minion(direction: Vector2, target_position: Vector2):
	update_minions()
	if len(minions.get_children()) >= minion_limit:
		return
	var minion = minion_scene.instantiate()
	var minion_position = global_position + direction * spawn_range
	minion.type = type
	minion.set_collision_layer_value(1, type == Type.ALLY)
	minion.set_collision_layer_value(2, type == Type.ENEMY)
	minion.unit_owner = get_parent()
	var summoning_portal = AnimatedSprite2D.new()
	summoning_portal.sprite_frames = summoning_portal_sprite
	add_child(summoning_portal)
	summoning_portal.play("summon")
	await summoning_portal.animation_finished
	summoning_portal.queue_free()
	minions.add_child(minion)
	minion.global_position = minion_position


func update_minions():
	for minion in minions.get_children():
		if get_parent().type != minion.type or get_parent().is_dead:
			minion.die()
