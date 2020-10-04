var semi_minor: float
var semi_major: float
var rotation: float

func _init(minor: float, major: float, rot: float = 0.0) -> void:
	self.semi_minor = minor
	self.semi_major = major
	self.rotation = rot

func get_position(angle: float, center_offset: Vector2) -> Vector2:
	var pos := Vector2(self.semi_major * cos(angle), self.semi_minor * sin(angle))
	return (pos + center_offset).rotated(self.rotation)
