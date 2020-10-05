tool
extends "NaiveOrbiter.gd"

const OCCLUDER_POINTS: int = 10

export var texture: Texture setget _set_texture
export var radius: float = 10.0 setget _set_radius

onready var _sprite: Sprite = $Sprite
onready var _collision_shape: CollisionShape2D = $CollisionShape2D
onready var _light_occluder: LightOccluder2D = $LightOccluder2D
onready var _gravity_collision_shape: CollisionShape2D = $Gravity/CollisionShape2D

func _ready() -> void:
	self._update_planet()

func _new_occluder(rad: float) -> OccluderPolygon2D:
	var occluder := OccluderPolygon2D.new()
	occluder.cull_mode = OccluderPolygon2D.CULL_CLOCKWISE

	var polygon := PoolVector2Array()
	for i in range(OCCLUDER_POINTS):
		var angle := i * TAU / OCCLUDER_POINTS
		polygon.append(Vector2(rad * cos(angle), rad * sin(angle)))

	occluder.polygon = polygon
	return occluder

func _new_shape(rad: float) -> CircleShape2D:
	var shape := CircleShape2D.new()
	shape.radius = rad
	return shape

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
	self._light_occluder.occluder = _new_occluder(self.radius)
	self._gravity_collision_shape.shape = _new_shape(25.0 * self.radius)


func _set_texture(value: Texture) -> void:
	texture = value
	self._update_planet()
	
func _set_radius(value: float) -> void:
	radius = value
	self._update_planet()
