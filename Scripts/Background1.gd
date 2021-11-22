extends "res://Scripts/Background.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#On met le mirroring aux dimensions de l'image
	get_node("ParallaxLayer").motion_mirroring.x = get_node("ParallaxLayer/Back1").rect_size.x * get_node("ParallaxLayer/Back1").rect_scale.x
	get_node("ParallaxLayer").motion_mirroring.y = (get_node("ParallaxLayer/Back1").rect_size.y * get_node("ParallaxLayer/Back1").rect_scale.y)*4


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
