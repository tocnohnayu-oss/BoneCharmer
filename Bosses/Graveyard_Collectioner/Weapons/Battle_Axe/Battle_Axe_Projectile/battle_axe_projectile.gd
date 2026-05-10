extends Projectile


var angle = 0.0
var radius = 10.0
var radius_speed = 10.0
var initial_speed = 20.0
var center:Vector2
var target_position: Vector2
var lifetime = 5.0
var parent_axe: Weapon
var turns_count = 0
var max_turns_count = 3
@onready var anim_player = $AnimationPlayer


func _ready() -> void:
	super._ready()
	is_penetrating = true
	max_penetrations = Penetrations.INFINITY
	update_parameteres()
	type = Type.BOSS
	center = (target_position + global_position) / 2
	radius = global_position.distance_to(target_position) / 2
	get_tree().create_timer(lifetime).timeout.connect(destroy)
	SPEED = 5.0
	ACCELERATION = 1.0
	kill_area_func = turn_count


func _physics_process(delta: float) -> void:
	angle += SPEED * delta
	SPEED += ACCELERATION * delta
	radius += radius_speed * delta
	var next_position = center + Vector2(cos(angle), sin(angle)) * radius
	look_at(next_position)
	global_position = next_position


func destroy():
	if kill_area:
		kill_area.queue_free()
	$CollisionShape2D.set_deferred("disabled", true)
	current_state = State.DESTROY
	set_deferred("monitorable", false) 
	set_deferred("monitoring", false)
	projectile_destroy.emit()
	anim_player.play(&"disappear")
	await anim_player.animation_finished
	queue_free()


func turn_count():
	if turns_count == max_turns_count:
		kill_area_func = destroy
		return
	turns_count += 1
