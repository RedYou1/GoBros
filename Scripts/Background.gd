extends ParallaxBackground


# Declare member variables here. Examples:


# Called when the node enters the scene tree for the first time.
func _ready():
	#On met le mirroring aux dimensions de l'image
	get_node("ParallaxLayer").motion_mirroring.x = get_node("ParallaxLayer/Back1").rect_size.x * get_node("ParallaxLayer/Back1").rect_scale.x
	get_node("ParallaxLayer").motion_mirroring.y = get_node("ParallaxLayer/Back1").rect_size.y * get_node("ParallaxLayer/Back1").rect_scale.y


func _process(delta: float) -> void:
	pass
