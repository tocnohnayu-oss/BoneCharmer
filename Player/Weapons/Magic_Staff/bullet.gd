extends Projectile

func _ready() -> void:
	super._ready()
	if OS.is_debug_build() and not get_tree().get_first_node_in_group("Main_Scene").is_mobile:
		damage = 100.0


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
