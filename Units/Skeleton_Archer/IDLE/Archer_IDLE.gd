extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var sprite = actor.sprite
	if sprite.animation in ["bow_loading", "arrow_release"] and sprite.is_playing:
		return FAILURE
	var idle_timer: Timer = actor.idle_timer
	actor.sprite.play("idle")
	if idle_timer.time_left <= 0:
		blackboard.set_value("is_ready_to_walk", true)
		idle_timer.start()
	return SUCCESS
