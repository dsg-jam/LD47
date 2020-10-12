extends "Goal.gd"

const Planet := preload("Planet.gd")
const Progress := preload("res://ui/Progress.gd")

class InteractionTarget:
	var target: Node2D
	var start_ticks_msec: int
	
	func _init(target_: Node2D) -> void:
		self.target = target_
		self.start_ticks_msec = OS.get_ticks_msec()
	
	func ticks_msec() -> int:
		return OS.get_ticks_msec() - self.start_ticks_msec
	
	func progress(total: float) -> float:
		return self.ticks_msec() / (1000.0 * total)

export var interaction_time: float = 10.0

var _interaction_target: InteractionTarget

onready var _ui_progress: Progress = get_tree().current_scene.get_node(@"Ui").progress
onready var _planet_interaction: Area2D = get_node(@"../Interaction")
onready var _planet_interaction_sprite: Sprite = _planet_interaction.get_node(@"Sprite")

func _ready() -> void:
	var _err
	_err = self._planet_interaction.connect("body_entered", self, "_on_Interaction_body_entered")
	_err = self._planet_interaction.connect("body_exited", self, "_on_Interaction_body_exited")

func _process(_delta: float) -> void:
	if self._interaction_target:
		var progress := self._interaction_target.progress(self.interaction_time)
		var complete := false
		if progress >= 1.0:
			complete = true
			progress = 1.0

		self._ui_progress.set_progress(progress)
		if complete:
			self._interaction_end()
			self.emit_goal_completed()

func _interaction_start(body: Node2D) -> void:
	self._interaction_target = InteractionTarget.new(body)
	self._planet_interaction_sprite.visible = true

func _interaction_end() -> void:
	self._interaction_target = null
	self._planet_interaction_sprite.visible = false
	self._ui_progress.hide()

func _on_Interaction_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		self._interaction_start(body)

func _on_Interaction_body_exited(body: Node) -> void:
	if self._interaction_target and body == self._interaction_target.target:
		self._interaction_end()
