extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var player = get_tree().get_first_node_in_group("Player")
	if not player or actor.type == actor.Type.ENEMY:
		return FAILURE
	var dist_to_player = actor.global_position.distance_to(player.global_position)
	if actor.to_player_max_range <= dist_to_player and dist_to_player >= actor.to_player_min_range:
		return SUCCESS
	else:
		actor.velocity = Vector2.ZERO
		return FAILURE
