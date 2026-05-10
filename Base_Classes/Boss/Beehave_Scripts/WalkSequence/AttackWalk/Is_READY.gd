extends BlackboardHasCondition


func tick(actor: Node, blackboard: Blackboard) -> int:
	if blackboard.get_value("is_ready_to_walk"):
		return SUCCESS
	else:
		return FAILURE
