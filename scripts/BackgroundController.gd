tool

extends Node2D


var camera_position
var background_tile_scene


func _ready():
	camera_position = get_node("../Camera2D")
	print(camera_position.get_camera_position())
	print(get_canvas_transform())
	background_tile_scene = load("res://prefabs/Background.tscn")
	var background_size =  background_tile_scene.instance().texture.get_size().y
	
	for i in range(0, ((get_viewport().size.x / 10) / background_size)):
		for j in range(0, ((get_viewport().size.y / 10) / background_size)):
			var background_tile = background_tile_scene.instance();
			background_tile.init((i * background_size) + (camera_position.get_camera_position().x - get_viewport().size.x / 2) / 10, (j * background_size) + (camera_position.get_camera_position().y - get_viewport().size.y / 2) / 10)
			add_child(background_tile)




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
