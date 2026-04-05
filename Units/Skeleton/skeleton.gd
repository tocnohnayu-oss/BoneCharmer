extends CharacterBody2D


var SPEED = 40.0
@export var max_health = 100.0
@export var damage = 20.0
var health = max_health
var type = Type.ENEMY
enum State {
	IDLE,
	ATTACK,
	WALK,
	HIT,
	FOLLOW_PLAYER,
	DEAD
}
enum Type {
	ALLY,
	ENEMY
}
var current_state = State.IDLE
@onready var sprite = $AnimatedSprite2D
@onready var triangle_sprite = $AnimatedSprite2D2
@onready var nav_agent = $NavigationAgent2D
@onready var idle_timer = $IdleTimer
@onready var hpbar_timer = $HPBarTimer
@onready var shadow = $Shadow
@onready var hpbar = $HPBar
@onready var anim_player = $AnimationPlayer
@onready var hitbox = $Hitbox
var target_position = global_position
var is_dead = false
var targeted_enemy = null


func _ready() -> void:
	hpbar.modulate = Color(255, 255, 255, 0.0)
	update_settings()
	shadow.visible = true
	shadow.modulate = Color(0, 0, 0, 0.4)
	shadow.scale = Vector2(0.6, 0.3)
	shadow.position = Vector2(0, 12)
	update_state(State.IDLE)


func _physics_process(delta: float) -> void:
	if is_dead:
		return
	if sprite.animation == &"attack":
		return
	var player = get_tree().get_first_node_in_group("Player")
	if global_position.distance_to(player.global_position) > 50 and type == Type.ALLY and current_state != State.ATTACK:
		follow_player()
	if nav_agent.is_navigation_finished() and current_state != State.IDLE:
		update_state(State.IDLE)
	elif nav_agent.is_navigation_finished():
		return
	var next_path_position = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_position)
	if direction:
		sprite.play("walk")
		sprite.flip_h = direction.x < 0
	velocity = direction * SPEED
	move_and_slide()


func update_state(new_state, target=null, value=0):
	current_state = new_state
	match(current_state):
		State.IDLE: idle()
		State.ATTACK: attack(target)
		State.WALK: walk()
		State.HIT: hit(0)
		State.FOLLOW_PLAYER: follow_player()


func idle():
	idle_timer.start()
	sprite.animation = &"idle"
	sprite.play()


func attack(target):
	targeted_enemy = target
	SPEED = 50.0

func walk():
	var offset = Vector2(randf_range(-50.0, 50.0), randf_range(-50.0, 50.0))
	nav_agent.target_position = global_position + offset
	SPEED = 25.0
	update_state(State.IDLE)


func follow_player():
	var player = get_tree().get_first_node_in_group("Player")
	nav_agent.target_position = player.global_position
	SPEED = 40.0


func hit(value):
	if is_dead:
		return
	health = max(0, health - value)
	update_hpbar()
	if health == 0:
		die()


func update_hpbar():
	hpbar.value = health
	anim_player.play("hpbar_appear")
	hpbar_timer.start(1)


func _on_idle_timer_timeout() -> void:
	if is_dead:
		return
	update_state(State.WALK)


func _on_hp_bar_timer_timeout() -> void:
	anim_player.play("hpbar_disappear")


func _on_attacked_by_player():
	get_tree().call_group("Player_Skeleton", "update_state", State.ATTACK, self)


func die():
	is_dead = true
	sprite.play("death")
	current_state = State.DEAD
	await sprite.animation_finished
	sprite.frame = 5


func update_settings():
	for group in ["Enemy", "Player_Skeleton"]:
		remove_from_group(group)
	add_to_group("Player_Skeleton" if type == Type.ALLY else "Enemy")
	set_collision_layer_value(1, type == Type.ALLY)
	set_collision_layer_value(2, type == Type.ENEMY)
	triangle_sprite.animation = &"ally" if type == Type.ALLY else &"enemy"
	triangle_sprite.play()
	hitbox.set_collision_layer_value(1, type == Type.ALLY)
	hitbox.set_collision_layer_value(2, type == Type.ENEMY)
	hitbox.set_collision_mask_value(2, type == Type.ALLY)
	hitbox.set_collision_mask_value(1, type == Type.ENEMY)


func revive(new_type):
	sprite.play("death", -1, true)
	await sprite.animation_finished
	type = new_type
	update_settings()
	is_dead = false
	update_state(State.IDLE)
	health = max_health


func _on_hitbox_area_entered(area: Area2D) -> void:
	var other_skeleton = area.get_parent()
	if other_skeleton.is_in_group("Enemy") == is_in_group("Enemy") or not other_skeleton.is_in_group("Skeleton"):
		print(other_skeleton.is_in_group("Enemy") == is_in_group("Enemy"), other_skeleton.is_in_group("Skeleton"))
		return
	update_state(State.ATTACK)
	sprite.play("attack")
	await sprite.animation_finished
	other_skeleton.hit(damage)
	if other_skeleton.is_dead:
		update_state(State.IDLE)
