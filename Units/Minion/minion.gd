extends Unit


# Called when the node enters the scene tree for the first time.
var lifetime = 10.0
func _ready() -> void:
	super._ready()
	scale = Vector2(0.5, 0.5)
	death_sound = preload("res://Assets/Units/Minion/Sounds/minion_death_sound.mp3")
	attack_sound = preload("res://Assets/Units/Minion/Sounds/minion_bite_sound.mp3")
	no_lifes_left = true
	SPEED = 50.0
	attack_range = 15.0
	get_tree().create_timer(lifetime).timeout.connect(func (): die())


func to_destroy():
	queue_free()
