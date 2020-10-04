extends Node2D

var _timer = null
var camera_position
export(PackedScene) var background_tile_scene
export(float, 0.1, 10.0) var fps = 1.0
var background_tiles = []


func _ready():
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(1.0/fps)
	_timer.set_one_shot(false)
	_timer.start()
	
	camera_position = get_node("../Camera2D")
	print(camera_position.get_camera_position())
	print(get_canvas_transform())
	var background_size =  background_tile_scene.instance().texture.get_size().y
	for i in range(ceil((get_viewport().size.x * camera_position.zoom.x / float(background_size)))):
		for j in range(ceil((get_viewport().size.y * camera_position.zoom.y / float(background_size)))):
			var background_tile = background_tile_scene.instance();
			background_tile.init((i * background_size) + (camera_position.get_camera_position().x - get_viewport().size.x / 2.0) * camera_position.zoom.x, (j * background_size) + (camera_position.get_camera_position().y - get_viewport().size.y / 2.0) * camera_position.zoom.y)
			add_child(background_tile)
			background_tiles.append(background_tile)


func _on_Timer_timeout():
	for background_tile in background_tiles:
		background_tile.animate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
