extends ConditionLeaf


var pos = Vector2.ZERO


func sort_enemies(e1, e2):
	var e1_distance = pos.distance_squared_to(e1.global_position)
	var e2_distance = pos.distance_squared_to(e2.global_position)
	return e1_distance < e2_distance

func tick(actor: Node, blackboard: Blackboard) -> int:
	if not blackboard.get_value("is_provocated"):
		return FAILURE
	var trigger_zone: Area2D = actor.trigger_zone
	var bodies = trigger_zone.get_overlapping_bodies().filter(func (body): return not body.is_dead)
	if not bodies:
		if not is_instance_valid(blackboard.get_value("targeted_enemy")):
			actor.stop_movement_around()
			blackboard.set_value("is_provocated", false)
		return FAILURE
	pos = actor.global_position
	bodies.sort_custom(sort_enemies)
	var nearest_enemy = bodies[0]
	blackboard.set_value("targeted_enemy", nearest_enemy)
	return SUCCESS
