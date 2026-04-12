extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var bodies:Array = actor.trigger_zone.get_overlapping_bodies()
	var units = bodies.filter(func (a): return a is Unit)
	var enemies = units.filter(func (a): return a.type == a.Type.ENEMY if actor.type == actor.Type.ALLY else a.type == a.Type.ALLY)
	enemies.sort_custom(func (a, b): return actor.global_position.distance_to(a.global_position) > actor.global_position.distance_to(b.global_position) and not a.is_dead)
	if not enemies:
		return FAILURE
	var prev_focused_enemy = blackboard.get_value("focused_enemy")
	var focused_enemy = enemies[0]
	if is_instance_valid(prev_focused_enemy) and not prev_focused_enemy.is_dead:
		focused_enemy = prev_focused_enemy
	blackboard.set_value("focused_enemy", focused_enemy)
	return SUCCESS
