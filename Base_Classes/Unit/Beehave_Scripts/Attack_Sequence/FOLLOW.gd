extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var sprite: AnimatedSprite2D = actor.sprite
	var nav_agent: NavigationAgent2D = actor.nav_agent
	var SPEED = actor.SPEED
	var focused_enemy = blackboard.get_value("focused_enemy")
	if not focused_enemy or focused_enemy.is_dead or focused_enemy.type == actor.type:
		actor.velocity = Vector2.ZERO
		return FAILURE
	nav_agent.target_position = focused_enemy.global_position
	var direction = actor.global_position.direction_to(nav_agent.get_next_path_position())
	actor.velocity = SPEED * direction
	sprite.play(&"walk")
	actor.move_and_slide()
	return SUCCESS
