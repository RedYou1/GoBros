extends Node2D


# Declare member variables here. Examples:
export (String) var scene_prochain_niveau

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("ColorRect").visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Quand le joueur est dans la zone de fin de niveau, on fait un fondu en noir
	#avant de changer de scène
	if get_node("Area").get_collider():
		print(get_node("Area").get_collider().name)
		if get_node("Area").get_collider().name == "Joueur":
			get_node("ColorRect").visible = true
			if get_node("ColorRect").modulate.a < 1:
				get_node("ColorRect").modulate.a += delta
			else:
				get_node("ColorRect").modulate.a = 1
				#Va à la scène définie dans les options
				Global.goto_scene(scene_prochain_niveau)
	else:
		if get_node("ColorRect").modulate.a > 0:
			get_node("ColorRect").modulate.a -= delta
		else:
			get_node("ColorRect").modulate.a = 0
			get_node("ColorRect").visible = false
