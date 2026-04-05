extends CharacterBody2D


const SPEED = 50.0
enum State {
	IDLE,
	WALK,
	ATTACK,
	HIT
}
var current_state = State.IDLE
@onready var weapons = [$MagicStaff, $MagicBook]
@onready var sprite = $AnimatedSprite2D
@onready var shadow = $Shadow
@onready var magic_staff = $MagicStaff
@onready var skeleton_scene = preload("res://Units/Skeleton/Skeleton.tscn")
@export var summon_area = 50.0

func _ready() -> void:
	shadow.visible = true
	change_weapon($MagicStaff)


func _physics_process(delta: float) -> void:
	if current_state == State.ATTACK or current_state == State.HIT:
		return
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	direction = direction.normalized()
	sprite.flip_h = direction.x < 0 if direction.x else sprite.flip_h
	var new_state = State.WALK if direction else State.IDLE
	if new_state != current_state:
		current_state = new_state
		update_state()
	velocity = direction * SPEED
	shadow.modulate = Color(0, 0, 0, 0.4)
	shadow.scale = Vector2(0.8, 0.4)
	shadow.position = Vector2(0, 27)
	move_and_slide()


func _input(event):
	if event.is_action_pressed("attack"):
		current_state = State.ATTACK
		update_state()
	elif event.is_action_pressed("summon"):
		revive_skeletons_in_area()

func update_state() -> void:
	var animation_type
	
	match(current_state):
		State.IDLE:
			animation_type = &"idle"
			idle()
		State.WALK:
			animation_type = &"walk"
			walk()
		State.ATTACK:
			#animation_type = &"attack"
			animation_type = &"idle"
			attack()
		State.HIT:
			#animation_type = &"hit"
			animation_type = &"idle"
			hit()
			
	sprite.animation = animation_type
	sprite.play()


func idle() -> void:
	pass


func walk() -> void:
	pass


func attack() -> void:
	var target = get_global_mouse_position()
	var attack_direction = target - global_position
	attack_direction = attack_direction.normalized()
	magic_staff.create_bullet(attack_direction, target)
	get_tree().call_group("Player_Skeleton", "follow_player")
	current_state = State.IDLE
	change_weapon($MagicStaff)
	$AudioStreamPlayer2D.play(0)


func hit() -> void:
	current_state = State.IDLE


func summon_skeletons_in_area():
	var skeleton = skeleton_scene.instantiate()
	skeleton.global_position = get_global_mouse_position()
	skeleton.type = skeleton.Type.ALLY
	skeleton.collision_layer = 1
	get_tree().get_first_node_in_group("Main_Scene").add_child(skeleton)
	change_weapon($MagicBook)


func revive_skeletons_in_area():
	var skeletons = get_tree().get_nodes_in_group("Skeleton")
	if not skeletons:
		return
	var target_area = get_global_mouse_position()
	var max_distance = 50.0
	for skeleton in skeletons:
		if target_area.distance_to(skeleton.global_position) <= max_distance and skeleton.is_dead:
			skeleton.revive(skeleton.Type.ALLY)
	change_weapon($MagicBook)


func change_weapon(new_weapon):
	for weapon in weapons:
			weapon.visible = weapon == new_weapon
