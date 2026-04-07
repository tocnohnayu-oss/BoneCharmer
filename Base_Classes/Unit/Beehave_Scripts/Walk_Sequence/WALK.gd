extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	var nav_agent:NavigationAgent2D = actor.nav_agent
	var offset = Vector2.ZERO
	if nav_agent.is_navigation_finished():
		offset = Vector2(randf_range(-35, 35), randf_range(-35, 35))
	var sprite: AnimatedSprite2D = actor.sprite
	var SPEED: float = actor.SPEED
	nav_agent.target_position = offset
	var next_path_position = nav_agent.get_next_path_position()
	var direction = actor.global_position.direction_to(next_path_position)
	if direction:
		sprite.play("walk")
		sprite.flip_h = direction.x < 0
	actor.velocity = direction * SPEED
	actor.move_and_slide()
	if nav_agent.is_navigation_finished():
		blackboard.set_value("is_ready_to_walk", false)
	return SUCCESS
