extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var nav_agent: NavigationAgent2D = actor.nav_agent
	if nav_agent.is_navigation_finished():
		var pos_offset = Vector2(randi_range(-100.0, 100.0), randi_range(-100.0, 100.0))
		var target_position = pos_offset + actor.global_position
		nav_agent.target_position = target_position
		blackboard.set_value("is_ready_to_walk", false)
		return FAILURE
	else:
		var next_move = nav_agent.get_next_path_position()
		var direction = actor.global_position.direction_to(next_move)
		actor.velocity = direction * blackboard.get_value("speed")
		actor.move_and_slide()
	return SUCCESS
