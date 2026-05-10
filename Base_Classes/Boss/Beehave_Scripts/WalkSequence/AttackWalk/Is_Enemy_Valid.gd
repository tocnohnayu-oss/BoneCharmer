extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var targeted_enemy: CharacterBody2D = blackboard.get_value("targeted_enemy")
	if is_instance_valid(targeted_enemy) and not targeted_enemy.is_dead:
		return SUCCESS
	else:
		return FAILURE
