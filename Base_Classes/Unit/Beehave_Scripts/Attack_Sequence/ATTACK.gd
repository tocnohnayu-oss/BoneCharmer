extends ActionLeaf


var focused_enemy = null


func tick(actor: Node, blackboard: Blackboard) -> int:
	var enemies: Array = actor.trigger_zone.get_overlapping_bodies().filter(func (a): return a is Unit).filter(func (a): return a.type == a.Type.ENEMY if actor.type == actor.Type.ALLY else a.type == a.Type.ALLY)
	var sprite: AnimatedSprite2D = actor.sprite
	var nav_agent: NavigationAgent2D = actor.nav_agent
	var SPEED = actor.SPEED
	enemies.sort_custom(func (a, b): return actor.global_position.distance_to(a.global_position) > actor.global_position.distance_to(b.global_position))
	if not enemies:
		return FAILURE
	if not focused_enemy:
		focused_enemy = enemies[0]
	elif focused_enemy.type == actor.type:
		return FAILURE
	elif focused_enemy.is_dead:
		focused_enemy = enemies[0]
	if actor.global_position.distance_to(focused_enemy.global_position) <= actor.attack_range:
		blackboard.set_value("is_attacking", true)
		actor.attack(focused_enemy)
		return RUNNING
		
	else:
		sprite.play("walk")
		nav_agent.target_position = focused_enemy.global_position
		var direction = actor.global_position.direction_to(nav_agent.get_next_path_position())
		actor.velocity = SPEED * direction
		if direction:
			sprite.flip_h = direction.x < 0
		actor.move_and_slide()
		return RUNNING
	blackboard.set_value("is_attacking", false)
	return SUCCESS
