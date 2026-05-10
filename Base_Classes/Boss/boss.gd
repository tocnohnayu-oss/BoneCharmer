class_name Boss
extends CharacterBody2D


@onready var sprite: AnimatedSprite2D = $Sprite
@onready var shadow: Sprite2D = $Shadow
@onready var nav_agent: NavigationAgent2D = $BossNavigationAgent
@onready var stream_player: AudioStreamPlayer2D = $BossStreamPlayer
@onready var hp_bar: TextureProgressBar = $HPBar/HPBar
@onready var beehave_tree = $BossBeehaveTree
@onready var blackboard: Blackboard = beehave_tree.blackboard
@onready var trigger_zone: Area2D = $TriggerZone
@onready var anim_tree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = anim_tree.get("parameters/playback")
var max_health = 500.0
var speed = 50.0
var health = max_health
var active_weapon: Weapon
var is_dead = false
enum Type {
	ALLY,
	ENEMY,
	BOSS
}
var type = Type.BOSS
enum PHASE {
	FIRST,
	SECOND,
	THIRD,
	FOURTH,
	FIFTH
}
var max_phase = PHASE.THIRD
var current_phase = PHASE.FIRST
var phase_change_interval = 5.0


func _ready() -> void:
	hp_bar.max_value = max_health
	hp_bar.value = max_health
	shadow.visible = true
	shadow.modulate = Color(0, 0, 0, 0.4)
	shadow.scale = Vector2(0.9, 0.45)
	shadow.position = Vector2(0, 35)
	blackboard.set_value("is_ready_to_walk", false)
	blackboard.set_value("is_provocated", false)
	blackboard.set_value("targeted_enemy", null)
	blackboard.set_value("speed", speed)
	current_phase = PHASE.FIRST


func _process(delta: float) -> void:
	if not is_dead:
		playback.travel("Idle")


func attack(target):
	if not active_weapon:
		print("NO ACTIVE WEAPON SELECTED!!  ", name)
		return false
	if not is_instance_valid(target) or target.is_dead:
		print("TARGET", target, " IS NOT VALID TO BE ATTACKED!!")
		return false
	var direction = active_weapon.global_position.direction_to(target.global_position)
	var target_position = target.global_position
	active_weapon.use_ability(direction, target_position)
	return true

func hit(value):
	if is_dead:
		return
	blackboard.set_value("is_provocated", true)
	health = max(0, health - value)
	update_hpbar()
	var calc_phase = min(phase_change_interval - floor(health / max_health * phase_change_interval) - 1, max_phase)
	if current_phase != calc_phase:
		current_phase = calc_phase
		_on_change_phase()
		print("BOSS ", scene_file_path.get_file().get_basename(), " CHANGED HIS PHASE TO ", PHASE.keys()[current_phase])
	if health == 0:
		die()

func update_hpbar():
	var tween = create_tween()
	tween.tween_property(hp_bar, "value", health, 0.3)
	tween.play()


func die():
	is_dead = true
	beehave_tree.enabled = false
	anim_tree.set("parameters/conditions/is_dead", true)


func _on_change_phase():
	pass
