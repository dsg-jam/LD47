extends Node

const Goal := preload("Goal.gd")

export(Array, PackedScene) var planet_goals: Array

var goal: Goal

var _rng := RandomNumberGenerator.new()

onready var _planets := get_tree().get_nodes_in_group("planet")

func _ready() -> void:
	self._rng.randomize()
	self._spawn_goal()

func _random_item(arr: Array) -> Object:
	var size := arr.size()
	if not size:
		return null
	return arr[self._rng.randi() % size]

func _random_goal() -> PackedScene:
	return self._random_item(self.planet_goals) as PackedScene

func _random_planet() -> Node:
	return self._random_item(self._planets) as Node

func _spawn_goal() -> void:
	var goal_scene := self._random_goal()
	var planet := self._random_planet()
	print(planet.name)
	
	var new_goal: Goal = goal_scene.instance()
	planet.add_child(new_goal)
	var _err := new_goal.connect("goal_completed", self, "_on_goal_completed")
	self.goal = new_goal
	
func _on_goal_completed() -> void:
	self.goal.queue_free()
	self._spawn_goal()
