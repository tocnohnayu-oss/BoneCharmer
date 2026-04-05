extends CharacterBody2D


var SPEED = 40.0
var health = 100.0
var type = Type.ENEMY
enum State {
	IDLE,
	ATTACK,
	WALK,
	HIT,
	FOLLOW_PLAYER
}
enum Type {
	ALLY,
	ENEMY
}
var current_state = State.IDLE
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var sprite = $AnimatedSprite2D
@onready var triangle_sprite = $AnimatedSprite2D2
@onready var nav_agent = $NavigationAgent2D
@onready var idle_timer = $IdleTimer
@onready var shadow = $Shadow
var target_position = global_position


func _ready() -> void:
	triangle_sprite.animation = &"ally" if type == Type.ALLY else &"enemy"
	triangle_sprite.play()
	shadow.visible = true
	shadow.modulate = Color(0, 0, 0, 0.4)
	shadow.scale = Vector2(0.6, 0.3)
	shadow.position = Vector2(0, 12)
	update_state(State.IDLE)


func _physics_process(delta: float) -> void:
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
	if global_position.distance_to(target.global_position) <= 5:
		sprite.animation = &"attack"
		sprite.play()
		await sprite.animation_finished
		target.hit(5)
		update_state(State.IDLE)
	else:
		nav_agent.target_position = target.global_position
		SPEED = 50.0


func walk():
	var offset = Vector2(randf_range(-50.0, 50.0), randf_range(-50.0, 50.0))
	nav_agent.target_position = global_position + offset
	SPEED = 25.0
	update_state(State.IDLE)


func follow_player():
	nav_agent.target_position = player.global_position
	SPEED = 40.0


func hit(value):
	health = max(0, health - value)


func _on_idle_timer_timeout() -> void:
	update_state(State.WALK)
