extends Projectile


var initial_rotation_value = rotation_degrees
var initial_global_position
var final_rotation
var rotation_duration = 0.5
var parent_spear: Weapon
@onready var anim_player = $AnimationPlayer


func _ready() -> void:
	super._ready()
	is_penetrating = true
	max_penetrations = Penetrations.INFINITY
	update_parameteres()
	ACCELERATION = 5.0
	SPEED = 20.0
	type = Type.BOSS
	final_rotation = get_angle_to(kill_position) + rotation + deg_to_rad(90.0)
	initial_global_position = global_position
	kill_area_func = spear_return
	start_rotating()


func _physics_process(delta: float) -> void:
	super._physics_process(delta)


func start_rotating():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "rotation", final_rotation, rotation_duration)


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


func spear_return():
	if kill_area:
		kill_area.queue_free()
	update_parameteres()
	kill_position = initial_global_position
	final_rotation = get_angle_to(kill_position) + rotation + deg_to_rad(90.0)
	kill_area = parent_spear.create_kill_area(initial_global_position)
	direction = global_position.direction_to(initial_global_position)
	start_rotating()
	kill_area_func = destroy
	
