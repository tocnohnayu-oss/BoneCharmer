extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	blackboard.set_value("is_ready_to_walk", true)
	return SUCCESS
