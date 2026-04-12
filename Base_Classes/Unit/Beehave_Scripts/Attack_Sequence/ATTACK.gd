extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var focused_enemy = blackboard.get_value("focused_enemy")
	if not focused_enemy or focused_enemy.is_dead:
		return FAILURE
	var is_near = actor.global_position.distance_to(focused_enemy.global_position) <= actor.attack_range 
	var is_animation = actor.sprite.is_playing() and actor.sprite.animation in actor.attack_animations
	if is_near and not is_animation and blackboard.get_value("is_ready_to_attack"):
		var direction = actor.global_position.direction_to(focused_enemy.global_position)
		actor.get_flipped_h(direction.x < 0)
		actor.attack(focused_enemy)
	elif not is_near:
		return FAILURE
	return SUCCESS
