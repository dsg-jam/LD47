extends RigidBody2D

const TARGET_GROUP: String = "enemy-target"

export(float) var speed: float = 10.0

var _target: RigidBody2D
var _rng := RandomNumberGenerator.new()

func _physics_process(_delta: float):
	var my_pos := self.position
	if self._target:
		var pos_offset := _target.position - my_pos
		self.add_central_force(pos_offset * speed)
	else:
		var x := self._rng.randf_range(-1.0, 1.0)
		var y := self._rng.randf_range(-1.0, 1.0)
		self.add_central_force(Vector2(x, y))

func _on_Area2D_body_entered(body: Node):
	if body.is_in_group(TARGET_GROUP):
		self._target = body

func _on_Area2D_body_exited(body: Node):
	if body.is_in_group(TARGET_GROUP):
		self._target = null
