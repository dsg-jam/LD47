extends RigidBody2D

export var accel_mul: float = 100.0
export var turn_speed: float = 100.0

onready var acceleration_sprite: Sprite = $Acceleration

func _integrate_forces(_state: Physics2DDirectBodyState) -> void:
	var x := Input.get_action_strength("right") - Input.get_action_strength("left")
	self.applied_torque = x * self.turn_speed
	var y := Input.get_action_strength("up") - Input.get_action_strength("down")
	self.applied_force = y * self.accel_mul * self.transform.basis_xform(Vector2.UP)

func _process(_delta: float) -> void:
	var vel := self.linear_velocity
	self.show_indicator(vel)

func show_indicator(v: Vector2) -> void:
	self.acceleration_sprite.region_rect.size.y = v.length()
	self.acceleration_sprite.global_position = self.position + v / 2.0
	self.acceleration_sprite.global_rotation = -v.angle_to(Vector2.UP)
