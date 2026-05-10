extends Boss


@onready var battle_axe: Weapon = $Weapons/BattleAxe
@onready var spear: Weapon = $Weapons/Spear
@onready var weapons = $Weapons
var angle = 0
var center
var radius = 50.0
var is_moving_around = false
var rotating_speed = speed / 25
var rotate_position
var additional_weapons = []
var time = 0.0

func _ready() -> void:
	super._ready()
	max_health = 2000.0
	health = max_health
	hp_bar.max_value = max_health
	hp_bar.value = max_health
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -30)
	active_weapon = spear
	blackboard.set_value("active_weapon", active_weapon)
	for weapon: Weapon in [battle_axe, spear]:
		weapon.type = weapon.Type.BOSS
		weapon.update_collisions()


func _physics_process(delta: float) -> void:
	if is_moving_around and blackboard.get_value("is_provocated"):
		if nav_agent.is_navigation_finished():
			nav_agent.target_position = movement_around(blackboard.get_value("targeted_enemy"), delta)
		var next_move = nav_agent.get_next_path_position()
		var direction = global_position.direction_to(nav_agent.get_next_path_position())
		velocity = speed * direction
		move_and_slide()


func _process(delta: float) -> void:
	super._process(delta)
	if is_dead:
		return
	time += delta
	for add_weapon in additional_weapons:
		var rotation_value = (speed / 25) * delta
		add_weapon.rotation += rotation_value
		for weapon in add_weapon.get_children():
			weapon.rotation = sin(time * 5.0) * deg_to_rad(15.0) - add_weapon.rotation


func movement_around(target, delta):
	angle += rotating_speed * delta
	var next_position = center + Vector2(cos(angle), sin(angle)) * radius
	return next_position


func start_movement_around(target):
	center = target.global_position
	is_moving_around = true
	set_collision_mask_value(3, false)


func stop_movement_around():
	is_moving_around = false
	set_collision_mask_value(3, true)


func die():
	super.die()
	stop_movement_around()
	for add_weapon in additional_weapons:
		add_weapon.visible = false
	additional_weapons.clear()


func _on_change_phase():
	var new_weapons: Node2D = weapons.duplicate()
	var rotation_offset = 45.0 * current_phase
	new_weapons.rotation_degrees = rotation_offset
	var weapons_children = new_weapons.get_children()
	weapons_children[0].rotation_degrees = -21.4 - rotation_offset
	weapons_children[1].rotation_degrees = -45.0 - rotation_offset
	for weapon in weapons_children:
		weapon.type = Type.BOSS
		weapon.visible = true
	additional_weapons.append(new_weapons)
	add_child(new_weapons)


func rand_free_weapon():
	var all_weapons = []
	all_weapons.append_array(weapons.get_children())
	for add_weapon in additional_weapons:
		all_weapons.append_array(add_weapon.get_children())
	all_weapons = all_weapons.filter(func (a): return a.is_ready)
	return all_weapons.pick_random() if not all_weapons.is_empty() else null
