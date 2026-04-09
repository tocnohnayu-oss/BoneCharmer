extends Weapon



func _ready() -> void:
	super._ready()
	bullet_scene = preload("res://Units/Skeleton_Archer/Weapons/Bow/Arrow/Arrow.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
