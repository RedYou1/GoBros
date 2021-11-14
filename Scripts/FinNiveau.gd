extends ColorRect


# Declare member variables here. Examples:
export (String) var scene_prochain_niveau

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_node("RayCast2D").get_collider():
		if get_node("RayCast2D").get_collider().name == "Joueur":
			Global.goto_scene(scene_prochain_niveau)
