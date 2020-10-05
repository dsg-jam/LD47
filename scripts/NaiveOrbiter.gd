tool
extends KinematicBody2D

const Ellipse := preload("Ellipse.gd")

export var periapsis: float = 50.0 setget _set_periapsis
export var apoapsis: float = 100.0 setget _set_apoapsis
export(float, -4, 4) var orbit_rotation: float = 0.0 setget _set_orbit_rotation
export(float, -4, 4) var angle_offset: float = 0.0
export var orbital_period: float = 10.0
export var static_target: NodePath setget _set_static_target
export var run_in_editor: bool = false

export var editor_path_active: bool = true
export var editor_path_points: int = 50
export var editor_path_color := Color(0.8, 1.0, 1.0, 0.5)
export(float, 0, 10) var editor_path_width: float = 2.0

var target: Node2D
var linear_velocity: Vector2
var _ellipse: Ellipse

func _ready() -> void:
	self._update_ellipse()
	self.position = calculate_position()

func _physics_process(_delta: float) -> void:
	if Engine.editor_hint:
		if not self.run_in_editor:
			self.position = self.position_at_time(0.0)
			return

	var next_pos := calculate_position()
	self.linear_velocity = next_pos - self.position
	var collision := self.move_and_collide(self.linear_velocity)
	if collision:
		# if we, for whatever reason, collided with something else
		# we set the veloocity to the distance we ended up travelling before the
		# collision.
		self.linear_velocity = collision.travel

func _process(_delta: float) -> void:
	if Engine.editor_hint:
		self.update()

func _draw() -> void:
	if not Engine.editor_hint or not self.editor_path_active:
		return

	var delta_angle := TAU / self.editor_path_points
	for i in range(self.editor_path_points):
		var start_angle := i * delta_angle
		var start := self.position_at_angle(start_angle)
		var end := self.position_at_angle(start_angle + delta_angle)
		self.draw_line(start - self.position, end - self.position, self.editor_path_color, self.editor_path_width)

func position_at_angle(angle: float) -> Vector2:
	var global_offset := Vector2.ZERO
	if self.target:
		global_offset = self.target.position
	var center_offset := (apoapsis - periapsis) / 2.0
	var pos := self._ellipse.get_position(angle, center_offset * Vector2.RIGHT)
	return pos + global_offset

func position_at_time(t: float) -> Vector2:
	var angle := self.angle_offset + t * (TAU / orbital_period)
	return self.position_at_angle(angle)

func calculate_position() -> Vector2:
	return self.position_at_time(OS.get_ticks_msec() / 1000.0)

func _update_ellipse() -> void:
	var major := (self.periapsis + self.apoapsis) / 2.0
	var eccentricity := 1.0 - (2.0 / ((self.apoapsis / self.periapsis) + 1.0))
	var minor := major * sqrt(1 - pow(eccentricity, 2.0))
	self._ellipse = Ellipse.new(minor, major, self.orbit_rotation)
	
	if self.static_target:
		self.target = get_node_or_null(self.static_target)

func _set_periapsis(value: float) -> void:
	periapsis = value
	self._update_ellipse()
	
func _set_apoapsis(value: float) -> void:
	apoapsis = value
	self._update_ellipse()

func _set_orbit_rotation(value: float) -> void:
	orbit_rotation = value
	self._update_ellipse()

func _set_static_target(value: NodePath) -> void:
	static_target = value
	self._update_ellipse()
