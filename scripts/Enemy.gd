extends KinematicBody2D


var velocity = Vector2()
export var speed = 10
var targeting_player = false
var player

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if targeting_player:
		target_player(player)
	else:
		random_position()
	velocity = velocity.normalized() * speed
	rotation = velocity.angle() + PI/2
	

func target_player(body):
	velocity.x = body.position.x - get_position().x
	velocity.y = body.position.y - get_position().y
	


func random_position():
	velocity.x += rng.randf_range(-1.0, 1.0)
	velocity.y += rng.randf_range(-1.0, 1.0)

func _physics_process(delta):
	velocity = move_and_slide(velocity)


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		targeting_player = true;
		player = body


func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		targeting_player = false;
