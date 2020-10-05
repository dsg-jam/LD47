var semi_minor: float
var semi_major: float
var rotation: float

func _init(minor: float, major: float, rot: float = 0.0) -> void:
	self.semi_minor = minor
	self.semi_major = major
	self.rotation = rot

func get_point(angle: float) -> Vector2:
	return Vector2(self.semi_major * cos(angle), self.semi_minor * sin(angle))

func get_position(angle: float, center_offset: Vector2) -> Vector2:
	return (self.get_point(angle) + center_offset).rotated(self.rotation)
