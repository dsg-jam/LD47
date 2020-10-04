tool
extends KinematicBody2D

const Ellipse := preload("Ellipse.gd")

export var periapsis: float = 50.0 setget _set_periapsis
export var apoapsis: float = 100.0 setget _set_apoapsis
export(float, -4, 4) var orbit_rotation: float = 0.0 setget _set_orbit_rotation
export(float, -4, 4) var angle_offset: float = 0.0
export var orbital_period: float = 10.0
export var static_target: NodePath
export var run_in_editor: bool = false

export var editor_path_active: bool = true
export var editor_path_points: int = 50
export var editor_path_color := Color(0.8, 1.0, 1.0, 0.5)
export(float, 0, 10) var editor_path_width: float = 2.0

var target: Node2D
var _ellipse: Ellipse

func _ready() -> void:
	if self.static_target:
		self.target = get_node(self.static_target)
	
	self._update_ellipse()
	self.position = calculate_position()

func _physics_process(_delta: float) -> void:
	if Engine.editor_hint:
		if not self.run_in_editor:
			self.position = self.calculate_position_at_time(0.0)
			return

	var next_pos := calculate_position()
	var _vel := self.move_and_collide(next_pos - self.position)

func _process(_delta: float) -> void:
	if Engine.editor_hint:
		self.update()

func _draw() -> void:
	if not Engine.editor_hint or not self.editor_path_active:
		return

	var delta_angle := TAU / self.editor_path_points
	var offset := self._get_offset()
	for i in range(self.editor_path_points):
		var start_angle := i * delta_angle
		var start := self._ellipse.get_position(start_angle, offset)
		var end := self._ellipse.get_position(start_angle + delta_angle, offset)
		self.draw_line(start - self.position, end - self.position, self.editor_path_color, self.editor_path_width)

func _get_offset() -> Vector2:
	var offset := Vector2((apoapsis - periapsis) / 2.0, 0.0)
	if self.target:
		offset += self.target.position
	return offset

func calculate_position_at_time(t: float) -> Vector2:
	var angle := self.angle_offset + t * (TAU / orbital_period)
	var offset := self._get_offset()
	return self._ellipse.get_position(angle, offset)

func calculate_position() -> Vector2:
	return self.calculate_position_at_time(OS.get_ticks_msec() / 1000.0)

func _update_ellipse() -> void:
	var major := (self.periapsis + self.apoapsis) / 2.0
	var eccentricity := 1.0 - (2.0 / ((self.apoapsis / self.periapsis) + 1.0))
	var minor := major * sqrt(1 - pow(eccentricity, 2.0))
	self._ellipse = Ellipse.new(major, minor, self.orbit_rotation)

func _set_periapsis(value: float) -> void:
	periapsis = min(value, self.apoapsis)
	self._update_ellipse()
	
func _set_apoapsis(value: float) -> void:
	apoapsis = max(value, self.periapsis)
	self._update_ellipse()

func _set_orbit_rotation(value: float) -> void:
	orbit_rotation = value
	self._update_ellipse()
