class_name Projectile
extends Area2D


@onready var sprite = $AnimatedSprite2D
@export var direction = Vector2.ZERO
var init_speed = 20.0
@export var SPEED = init_speed
@export var ACCELERATION = 10.0
var kill_position = Vector2.ZERO
var flied_distance = Vector2.ZERO
enum Type {
	ALLY,
	ENEMY,
	BOSS
}
var type = Type.ALLY
var damage = 0
enum State {
	FLY,
	DESTROY
}
enum Penetrations {
	INFINITY,
	SINGLE
}
var current_state = State.FLY
var is_destroying_by_projectiles = false
var kill_area = null
var kill_area_func = destroy
var is_penetrating = false
var max_penetrations = Penetrations.SINGLE * 10
var left_penetrations
signal projectile_destroy()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(10.0).timeout.connect(func (): destroy())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if current_state != State.FLY:
		return
	SPEED += SPEED * (ACCELERATION / 100) 
	var velocity = direction * SPEED * delta
	flied_distance += velocity
	position += velocity


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Boss") and type != Type.BOSS:
		deal_damage(body)
	if body is not Unit and not is_destroying_by_projectiles:
		return
	if body.type != type and current_state != State.DESTROY:
		deal_damage(body)


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()


func destroy():
	if kill_area:
		kill_area.queue_free()
	$CollisionShape2D.set_deferred("disabled", true)
	current_state = State.DESTROY
	set_deferred("monitorable", false) 
	set_deferred("monitoring", false)
	projectile_destroy.emit()
	sprite.play("destroy")


func _on_area_entered(area: Area2D) -> void:
	if kill_area and area == kill_area:
		kill_area_func.call()


func update_parameteres():
	left_penetrations = max_penetrations
	flied_distance = Vector2.ZERO
	SPEED = init_speed


func check_penetration_ability():
	if (is_penetrating and left_penetrations >= Penetrations.SINGLE) or max_penetrations == Penetrations.INFINITY:
		left_penetrations -= Penetrations.SINGLE
		return true
	else:
		return false


func deal_damage(target):
	target.hit(damage)
	if not check_penetration_ability():
		destroy()
