extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var bodies:Array = actor.trigger_zone.get_overlapping_bodies()
	var units = bodies.filter(func (a): return a is Unit)
	var filtered_units = units.filter(func (a): return a.type == a.Type.ENEMY if actor.type == actor.Type.ALLY else a.type == a.Type.ALLY)
	if not filtered_units or blackboard.get_value("is_attacking"):
		return FAILURE
	var nav_agent: NavigationAgent2D = actor.nav_agent
	nav_agent.target_position = actor.global_position
	return SUCCESS
