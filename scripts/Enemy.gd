tool
extends RigidBody2D

const TARGET_GROUP: String = "enemy-target"
const PLANET_GROUP: String = "planet"

export(float) var accel: float = 10.0

var GRAVITY_MULTIPLIER = 500

var _target: RigidBody2D
var orbiting_planet
var _rng := RandomNumberGenerator.new()

func acceleration(pos1, pos2, mass):
	var gravity = mass * GRAVITY_MULTIPLIER
	var direction = pos1 - pos2
	var length = direction.length()
	var normal = direction.normalized()

	return normal * (gravity / pow(length, 2))


func _integrate_forces(_state: Physics2DDirectBodyState) -> void:
	var my_pos := self.position
	if self.orbiting_planet:
		
		var acc = acceleration(orbiting_planet.position, position, 100)

		set_linear_velocity(acc.rotated(TAU/4))
		
	elif self._target:
		var pos_offset := _target.position - my_pos
		self.applied_force = pos_offset.normalized() * accel
	else:
		var x := self._rng.randf_range(-1.0, 1.0)
		var y := self._rng.randf_range(-1.0, 1.0)
		self.applied_force = Vector2(x, y).normalized() * accel


func _on_Area2D_body_entered(body: Node):
	if body.is_in_group(PLANET_GROUP):
		orbiting_planet = body
	elif body.is_in_group(TARGET_GROUP):
		self._target = body

func _on_Area2D_body_exited(body: Node):
	#if body.is_in_group(PLANET_GROUP):
	#	orbiting_planet = null
	if body.is_in_group(TARGET_GROUP):
		self._target = null
