extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.start_movement_around(blackboard.get_value("targeted_enemy"))
	return SUCCESS
