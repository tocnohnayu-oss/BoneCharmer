extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	return SUCCESS if blackboard.get_value("is_dead") else FAILURE
