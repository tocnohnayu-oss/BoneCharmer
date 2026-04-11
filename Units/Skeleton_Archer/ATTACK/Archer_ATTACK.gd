extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var focused_enemy = blackboard.get_value("focused_enemy")
	if not focused_enemy or focused_enemy.is_dead:
		return FAILURE
	var is_near = actor.global_position.distance_to(focused_enemy.global_position) <= actor.attack_range 
	var is_animation = actor.sprite.is_playing() and actor.sprite.animation in ["arrow_release", "bow_loading"]
	if is_near and not is_animation:
		actor.attack(focused_enemy)
	elif not is_near:
		return FAILURE
	return SUCCESS
