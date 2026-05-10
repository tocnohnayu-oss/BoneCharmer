extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var mb_weapon = actor.rand_free_weapon()
	if mb_weapon == null:
		return FAILURE
	actor.active_weapon = actor.rand_free_weapon()
	blackboard.set_value("active_weapon", actor.active_weapon)
	return SUCCESS
