class_name Unit
extends CharacterBody2D


@onready var sprite = $UnitAnimatedSprite as AnimatedSprite2D
@onready var triangle_sprite = $TeamTriangle
@onready var nav_agent = $UnitNavigationAgent
@onready var idle_timer = $IdleTimer
@onready var hpbar_timer = $HPBar/HPBarTimer
@onready var shadow = $Shadow
@onready var hpbar = $HPBar/HPBar
@onready var anim_player = $AnimationPlayer
@onready var hitbox = $Hitbox
@onready var audio_streamer = $UnitAudioStreamPlayer
@onready var death_sound: AudioStreamMP3
@onready var spawn_sound: AudioStreamMP3
@onready var attack_sound: AudioStreamMP3
@onready var beehave_tree = $BeehaveTree
@onready var unit_collision = $UnitCollision
enum Type {
	ALLY,
	ENEMY
}
var type = Type.ENEMY
var is_dead = false
var no_lifes_left = false
var SPEED = 30.0
@export var max_health = 100.0
@export var damage = 20.0
var health = max_health
var blackboard
var to_player_min_range = 10.0
var to_player_max_range = 30.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blackboard = beehave_tree.blackboard
	hpbar.modulate = Color(255, 255, 255, 0.0)
	update_settings()
	shadow.visible = true
	shadow.modulate = Color(0, 0, 0, 0.4)
	shadow.scale = Vector2(0.6, 0.3)
	shadow.position = Vector2(0, 12)
	blackboard.set_value("is_ready_to_walk", false)


func hit(value):
	if is_dead:
		return
	health = max(0, health - value)
	update_hpbar()
	if health == 0:
		for group in ["Enemy", "Player_Skeleton"]:
			remove_from_group(group)
		beehave_tree.enabled = false
		unit_collision.disabled = true
		is_dead = true
		blackboard.set_value("is_dead", is_dead)
		if sprite.animation != "death":
			sprite.play("death")
			audio_streamer.stream = death_sound
			audio_streamer.play()
		await sprite.animation_finished
		if no_lifes_left:
			triangle_sprite.visible = false
		sprite.frame = sprite.sprite_frames.get_frame_count(&"death") - 1
		beehave_tree.enabled = false


func die():
	is_dead = true


func update_hpbar():
	hpbar.value = health
	anim_player.play("hpbar_appear")
	hpbar_timer.start(1)



func update_settings():
	for group in ["Enemy", "Player_Skeleton"]:
		remove_from_group(group)
	add_to_group("Player_Skeleton" if type == Type.ALLY else "Enemy")
	set_collision_layer_value(1, type == Type.ALLY)
	set_collision_layer_value(2, type == Type.ENEMY)
	triangle_sprite.animation = &"ally" if type == Type.ALLY else &"enemy"
	health = max_health
	triangle_sprite.play()
	hitbox.set_collision_layer_value(1, type == Type.ALLY)
	hitbox.set_collision_layer_value(2, type == Type.ENEMY)
	hitbox.set_collision_mask_value(2, type == Type.ALLY)
	hitbox.set_collision_mask_value(1, type == Type.ENEMY)


func revive(new_type):
	if no_lifes_left:
		return
	type = new_type
	is_dead = false
	health = max_health
	blackboard.set_value("is_dead", is_dead)
	triangle_sprite.animation = &"ally" if type == Type.ALLY else &"enemy"
	audio_streamer.stream = spawn_sound
	audio_streamer.play()
	sprite.stop()
	sprite.play("death", -1, true)
	await sprite.animation_finished
	beehave_tree.enabled = true
	update_settings()
	no_lifes_left = true
	unit_collision.disabled = false
	nav_agent.navigation_layers = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hp_bar_timer_timeout() -> void:
	anim_player.play("hpbar_disappear")
