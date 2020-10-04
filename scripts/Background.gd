extends Sprite

func _ready():
	pass

func animate():
	if frame == 3:
		frame = 0
	else:
		frame += 1

func init(pos_x, pos_y):
	position.x = pos_x
	position.y = pos_y
