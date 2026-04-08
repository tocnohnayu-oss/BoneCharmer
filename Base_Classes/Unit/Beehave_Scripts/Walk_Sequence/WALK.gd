extends ActionLeaf


var offset = Vector2.ZERO


func tick(actor: Node, blackboard: Blackboard) -> int:
	var nav_agent:NavigationAgent2D = actor.nav_agent
	var sprite: AnimatedSprite2D = actor.sprite
	var SPEED: float = actor.SPEED * 0.5
	var next_path_position = nav_agent.get_next_path_position()
	var direction = actor.global_position.direction_to(next_path_position)
	if direction:
		if sprite.animation != "walk":
			sprite.play("walk")
		sprite.flip_h = direction.x < 0
	actor.velocity = direction * SPEED
	actor.move_and_slide()
	if nav_agent.is_navigation_finished():
		offset = Vector2(randf_range(-50, 50), randf_range(-50, 50))
		nav_agent.target_position = offset + actor.global_position
		blackboard.set_value("is_ready_to_walk", false)
		return SUCCESS
	return SUCCESS
