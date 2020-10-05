extends RigidBody2D

const TARGET_GROUP: String = "enemy-target"
const PLANET_GROUP: String = "planet"

export(float) var accel: float = 10.0

var _target: RigidBody2D
var orbiting_planet
var _rng := RandomNumberGenerator.new()

var is_orbiting = false

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if self.orbiting_planet:
		if is_orbiting:
			return
		var gravity = state.total_gravity
		self.set_linear_velocity(Vector2(0, (TAU*50)/60) * state.step + ((mass * sqrt((gravity.length() * orbiting_planet.position.distance_to(position)))) * gravity.rotated(TAU/4).normalized()))

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group(PLANET_GROUP):
		orbiting_planet = body
	elif body.is_in_group(TARGET_GROUP):
		self._target = body


func _on_Area2D_body_exited(body: Node):
	if body.is_in_group(TARGET_GROUP):
		self._target = null
