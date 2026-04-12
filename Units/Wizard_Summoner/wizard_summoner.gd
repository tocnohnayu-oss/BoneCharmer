extends Unit


@onready var summoning_staff = $SummoningStaff
@onready var attack_sound2 = preload("res://Assets/Units/Wizard_Summoner/Sounds/wizard_summoner_preparing_sound.mp3")
@onready var summon_timer: Timer = $SummonTimer


func _ready() -> void:
	super._ready()
	scale = Vector2(0.7, 0.7)
	attack_range = 100.0
	to_player_min_range = 20.0
	to_player_max_range = 60.0
	attack_range = 125.0
	attack_sound = preload("res://Assets/Units/Wizard_Summoner/Sounds/summoning_sound.mp3")
	death_sound = preload("res://Assets/Units/Wizard_Summoner/Sounds/wizard_summoner_death_sound.mp3")
	spawn_sound = preload("res://Assets/Units/Skeleton/Sounds/Skeleton_revive_spawn/skeleton_bone_crack_sound.mp3")
	active_weapon = summoning_staff
	attack_animations = ["attack_start", "attack_end"]


func update_settings():
	super.update_settings()
	summoning_staff.type = type


func die():
	super.die()
	summoning_staff.update_minions()

func attack(target):
	if is_dead or not is_instance_valid(target):
		return
	var target_position = target.global_position
	summon_timer.start()
	blackboard.set_value("is_ready_to_attack", false)
	sprite.play("attack_start")
	audio_streamer.stream = attack_sound
	audio_streamer.play()
	await sprite.animation_finished
	var minion_direction = global_position.direction_to(target_position)
	active_weapon.use_ability(minion_direction, target_position)
	sprite.play("attack_end")
	audio_streamer.stream = attack_sound2
	audio_streamer.play()
	blackboard.set_value("is_attacking", false)


func _on_summon_timer_timeout() -> void:
	blackboard.set_value("is_ready_to_attack", true)
