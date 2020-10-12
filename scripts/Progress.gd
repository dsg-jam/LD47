extends Control

onready var _label: Label = $Label

func set_progress(progress: float) -> void:
	self.visible = true
	self._label.text = String(round(100.0 * progress)) + "%"

func hide() -> void:
	self.visible = false
