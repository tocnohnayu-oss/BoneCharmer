extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var targeted_enemy = blackboard.get_value("targeted_enemy")
	return actor.attack(targeted_enemy)
