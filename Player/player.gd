extends CharacterBody2D


const SPEED = 50.0
enum State {
	IDLE,
	WALK,
	ATTACK,
	HIT
}
var current_state = State.IDLE
@onready var sprite = $AnimatedSprite2D
@onready var shadow = $Shadow


func _ready() -> void:
	shadow.visible = true


func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	direction = direction.normalized()
	sprite.flip_h = direction.x < 0 if direction.x else sprite.flip_h
	var new_state = State.WALK if direction else State.IDLE
	if new_state != current_state:
		current_state = new_state
		update_animation()
	velocity = direction * SPEED
	shadow.modulate = Color(0, 0, 0, 0.4)
	shadow.scale = Vector2(0.8, 0.4)
	shadow.position = Vector2(0, 27)
	move_and_slide()


func update_animation() -> void:
	var animation_type
	match(current_state):
		State.IDLE: animation_type = &"idle"
		State.WALK: animation_type = &"walk"
		State.ATTACK: animation_type = &"attack"
		State.HIT: animation_type = &"hit"
	sprite.animation = animation_type
	sprite.play()
