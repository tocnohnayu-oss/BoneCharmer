extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var player_position = get_tree().get_first_node_in_group("Player").global_position
	var nav_agent:NavigationAgent2D = actor.nav_agent
	var sprite: AnimatedSprite2D = actor.sprite
	var SPEED: float = actor.SPEED
	nav_agent.target_position = player_position
	var next_path_position = nav_agent.get_next_path_position()
	var direction = actor.global_position.direction_to(next_path_position)
	if direction:
		sprite.play("walk")
		sprite.flip_h = direction.x < 0
	actor.velocity = direction * SPEED
	actor.move_and_slide()
	return SUCCESS
