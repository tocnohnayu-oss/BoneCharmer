extends Area2D


@onready var sprite = $AnimatedSprite2D
@export var direction = Vector2.ZERO
@export var SPEED = 20.0
@export var ACCELERATION = 5.00
var kill_position = Vector2.ZERO
var flied_distance = Vector2.ZERO
var damage = 0
enum State {
	FLY,
	DESTROY
}
var current_state = State.FLY

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if current_state != State.FLY:
		return
	if global_position.distance_to(kill_position) <= 10.0:
		destroy()
	SPEED += SPEED * (ACCELERATION / 100) 
	var velocity = direction * SPEED * delta
	flied_distance += velocity
	position += velocity


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.hit(damage)
		destroy()


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()


func destroy():
		current_state = State.DESTROY
		sprite.play("destroy")
