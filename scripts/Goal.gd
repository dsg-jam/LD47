extends Node

signal goal_completed

func emit_goal_completed() -> void:
	self.emit_signal("goal_completed")
