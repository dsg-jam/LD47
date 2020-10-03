extends KinematicBody2D

export(float) var periapsis: float = 50.0 setget _set_periapsis
export(float) var apoapsis: float = 100.0 setget _set_apoapsis
export(float) var orbital_period: float = 10.0
export(float) var orbit_rotation: float = 0.0

var target: Node2D

var _ellipse_major: float
var _ellipse_minor: float

func _ready() -> void:
	self.position = calculate_position()
	self._update_values()

func _physics_process(_delta: float) -> void:
	var next_pos := calculate_position()
	var _vel := self.move_and_collide(next_pos - self.position)

func _target_offset() -> Vector2:
	if self.target:
		return self.target.position
	else:
		return Vector2.ZERO

func calculate_position() -> Vector2:
	var t := (TAU / orbital_period) * OS.get_ticks_msec() / 1000.0
	var pos := Vector2(_ellipse_major * cos(t), _ellipse_minor * sin(t))
	var offset := Vector2((apoapsis - periapsis) / 2.0, 0.0) + self._target_offset()
	return (pos + offset).rotated(orbit_rotation)

func _update_values() -> void:
	self._ellipse_major = (self.periapsis + self.apoapsis) / 2.0
	var eccentricity := 1.0 - (2.0 / ((self.apoapsis / self.periapsis) + 1.0))
	self._ellipse_minor = self._ellipse_major * sqrt(1 - pow(eccentricity, 2.0))

func _set_periapsis(value: float) -> void:
	periapsis = value
	self._update_values()
	
func _set_apoapsis(value: float) -> void:
	apoapsis = value
	self._update_values()
