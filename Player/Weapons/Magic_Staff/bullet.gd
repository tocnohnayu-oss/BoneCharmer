extends Projectile

func _ready() -> void:
	super._ready()
	if OS.is_debug_build():
		damage = 100.0


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
