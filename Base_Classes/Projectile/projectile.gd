class_name Projectile
extends Area2D


@onready var sprite = $AnimatedSprite2D
@export var direction = Vector2.ZERO
@export var SPEED = 20.0
@export var ACCELERATION = 10.0
var kill_position = Vector2.ZERO
var flied_distance = Vector2.ZERO
enum Type {
	ALLY,
	ENEMY
}
var type = Type.ALLY
var damage = 0
enum State {
	FLY,
	DESTROY
}
var current_state = State.FLY

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_layer_value(1, type == Type.ALLY)
	set_collision_layer_value(2, type == Type.ENEMY)
	set_collision_mask_value(2, type == Type.ALLY)
	set_collision_mask_value(1, type == Type.ENEMY)


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
	if body.is_in_group("Enemy" if type == Type.ALLY else "Player_Skeleton"):
		body.hit(damage)
		destroy()


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()


func destroy():
		$CollisionShape2D.disabled = true
		current_state = State.DESTROY
		sprite.play("destroy")
