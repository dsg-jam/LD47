tool
extends "NaiveOrbiter.gd"

export var texture: Texture setget _set_texture
export var radius: float = 10.0 setget _set_radius

onready var _sprite: Sprite = $Sprite
onready var _collision_shape: CollisionShape2D = $CollisionShape2D
onready var _gravity_collision_shape: CollisionShape2D = $Gravity/CollisionShape2D

func _ready() -> void:
	self._update_planet()

func _update_planet() -> void:
	if not self._sprite:
		return

	var scale := 1.0
	if self.texture:
		scale /= self.texture.get_width() as float

	self._sprite.texture = self.texture
	var sprite_size := 2.0 * self.radius * scale
	self._sprite.scale = Vector2(sprite_size, sprite_size)

	self._collision_shape.shape = _new_shape(self.radius)
	self._gravity_collision_shape.shape = _new_shape(25.0 * self.radius)

func _new_shape(radius: float) -> CircleShape2D:
	var shape := CircleShape2D.new()
	shape.radius = radius
	return shape

func _set_texture(value: Texture) -> void:
	texture = value
	self._update_planet()
	
func _set_radius(value: float) -> void:
	radius = value
	self._update_planet()
