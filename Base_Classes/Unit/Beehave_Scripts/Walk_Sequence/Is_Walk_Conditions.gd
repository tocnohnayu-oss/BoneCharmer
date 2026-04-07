extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	return SUCCESS if blackboard.get_value("is_ready_to_walk") else FAILURE
