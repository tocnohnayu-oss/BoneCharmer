extends Skeleton


# Called when the node enters the scene tree for the first time.
@onready var bow = $Bow
var attack_sound2 = preload("res://Assets/Units/Skeleton_Archer/Sounds/arrow_release.mp3")
func _ready() -> void:
	super._ready()
	to_player_min_range = 20.0
	to_player_max_range = 60.0
	attack_range = 125.0
	attack_sound = preload("res://Assets/Units/Skeleton_Archer/Sounds/bow_loading.mp3")
	active_weapon = bow
	attack_animations = ["arrow_release", "bow_loading"]


func update_settings():
	super.update_settings()
	bow.type = type

func attack(target):
	var arrow_direction = global_position.direction_to(target.global_position)
	bow.play("bow_loading")
	sprite.play("bow_loading")
	audio_streamer.stream = attack_sound
	audio_streamer.play()
	await bow.animation_finished
	bow.create_bullet(arrow_direction, target.global_position)
	audio_streamer.stream = attack_sound2
	audio_streamer.play()
	blackboard.set_value("is_attacking", false)
	bow.play("default")
