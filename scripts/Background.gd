extends Sprite


export(int, 1, 50) var fps = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if(OS.get_ticks_msec() % 1000/fps == 0):
		if(self.frame == 3):
			self.frame = 0
		else:
			self.frame += 1


func init(pos_x, pos_y):
	position.x = pos_x
	position.y = pos_y
