extends RigidBody2D

export var accel_mul: float = 1.0
export var turn_speed: float = 100.0

onready var acceleration_sprite: Sprite = $Acceleration

func _physics_process(delta: float) -> void:
	var x := Input.get_action_strength("right") - Input.get_action_strength("left")
	var y := Input.get_action_strength("up") - Input.get_action_strength("down")
	self.apply_torque_impulse(x * self.turn_speed * delta)
	self.add_central_force(y * self.accel_mul * self.transform.basis_xform(Vector2.UP))

func _process(_delta: float) -> void:
	var vel := self.applied_force
	self.show_indicator(vel)

func show_indicator(v: Vector2) -> void:
	self.acceleration_sprite.region_rect.size.y = v.length()
	self.acceleration_sprite.global_position = self.position + v / 2.0
	self.acceleration_sprite.global_rotation = -v.angle_to(Vector2.UP)
