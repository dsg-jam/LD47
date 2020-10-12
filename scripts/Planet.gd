tool
extends "NaiveOrbiter.gd"

const Progress := preload("Progress.gd")

class InteractionTarget:
	var target: Node2D
	var start_ticks_msec: int
	
	func _init(target_: Node2D) -> void:
		self.target = target_
		self.start_ticks_msec = OS.get_ticks_msec()
	
	func ticks_msec() -> int:
		return OS.get_ticks_msec() - self.start_ticks_msec
	
	func progress(total: float) -> float:
		return self.ticks_msec() / (1000.0 * total)

const OCCLUDER_POINTS: int = 10
const GRAVITY_RADIUS_SCALE: float = 1.0 / 10.0
# Without this the circle sprite is contained in the collision shape
# instead of sitting right outside of it
const INTERACTION_SPRITE_SCALE: float = 1.4
const INTERACTION_RADIUS_GROW: float = 20.0

export var texture: Texture setget _set_texture
export var radius: float = 10.0 setget _set_radius
export var interaction_time: float = 10.0

var _interaction_target: InteractionTarget

onready var _ui_progress: Progress = get_node(@"/root/Node2D/Ui").progress
onready var _sprite: Sprite = $Sprite
onready var _collision_shape: CollisionShape2D = $CollisionShape2D
onready var _light_occluder: LightOccluder2D = $LightOccluder2D
onready var _gravity: Area2D = $Gravity
onready var _gravity_collision_shape: CollisionShape2D = $Gravity/CollisionShape2D
onready var _interaction_collision_shape: CollisionShape2D = $Interaction/CollisionShape2D
onready var _interaction_sprite: Sprite = $Interaction/Sprite

func _ready() -> void:
	self._update_planet()

func _process(_delta: float) -> void:
	if self._interaction_target:
		var progress := self._interaction_target.progress(self.interaction_time)
		self._ui_progress.set_progress(progress)

func calculate_gravity_strength_at(rad: float) -> float:
	return self._gravity.gravity / pow(rad * self._gravity.gravity_distance_scale + 1, 2)

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

func _update_gravity_area() -> void:
	self._gravity.gravity = GRAVITY_RADIUS_SCALE * pow(self.radius, 2)
	self._gravity_collision_shape.shape = _new_shape(25.0 * self.radius)

func _update_interaction_area() -> void:
	var interaction_radius := INTERACTION_RADIUS_GROW + self.radius
	self._interaction_collision_shape.shape = _new_shape(interaction_radius)
	var sprite_size := INTERACTION_SPRITE_SCALE * 2.0 * interaction_radius / self._interaction_sprite.texture.get_width() as float
	self._interaction_sprite.scale = Vector2(sprite_size, sprite_size)
	self._interaction_sprite.visible = false

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
	
	self._update_gravity_area()
	self._update_interaction_area()

func _set_texture(value: Texture) -> void:
	texture = value
	self._update_planet()
	
func _set_radius(value: float) -> void:
	radius = value
	self._update_planet()

func _interaction_start(body: Node2D) -> void:
	self._interaction_target = InteractionTarget.new(body)
	self._interaction_sprite.visible = true

func _interaction_end() -> void:
	self._interaction_target = null
	self._interaction_sprite.visible = false
	self._ui_progress.hide()

func _on_Interaction_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		self._interaction_start(body)

func _on_Interaction_body_exited(body: Node) -> void:
	if self._interaction_target and body == self._interaction_target.target:
		self._interaction_end()
