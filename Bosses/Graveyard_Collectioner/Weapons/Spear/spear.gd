extends Weapon


@onready var spear_scene = preload("res://Bosses/Graveyard_Collectioner/Weapons/Spear/Spear_Projectile/spear_projectile.tscn")
var is_ready = true


func _ready() -> void:
	super._ready()
	ability_function = spear_attack
	type = Type.BOSS


func spear_attack(direction: Vector2, target_position: Vector2):
	if not is_ready:
		return
	target_position += target_position - global_position
	direction = global_position.direction_to(target_position)
	var new_spear = spear_scene.instantiate()
	set_collisions_to_projectile(new_spear)
	new_spear.global_position = global_position
	new_spear.kill_position = target_position
	new_spear.rotation = rotation
	new_spear.projectile_destroy.connect(_on_spear_destroy)
	new_spear.damage = damage
	new_spear.direction = direction
	new_spear.parent_spear = self
	visible = false
	is_ready = false
	new_spear.kill_area = create_kill_area(target_position)
	get_tree().get_first_node_in_group("Main_Scene").add_child(new_spear)


func _on_spear_destroy():
	get_tree().create_timer(cooldown).timeout.connect(_on_timer_finished)


func _on_timer_finished():
	is_ready = true
	visible = true
