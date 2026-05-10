class_name Skeleton
extends Unit




func _ready() -> void:
	super._ready()
	death_sound = preload("res://Assets/Units/Skeleton/Sounds/Skeleton_death/skeleton_death_sound.mp3")
	spawn_sound = preload("res://Assets/Units/Skeleton/Sounds/Skeleton_revive_spawn/skeleton_bone_crack_sound.mp3")
	attack_sound = preload("res://Assets/Units/Skeleton/Sounds/Skeleton_sword_slash/sword_slash_sound.mp3")
