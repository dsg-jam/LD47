extends RigidBody2D

export(float) var speed: float = 1.0

func get_input() -> Vector2:
	var x := Input.get_action_strength("right") - Input.get_action_strength("left")
	var y := Input.get_action_strength("down") - Input.get_action_strength("up")
	return Vector2(x, y).normalized()

func _physics_process(_delta: float) -> void:
	var input := get_input()
	self.add_central_force(input * speed)
