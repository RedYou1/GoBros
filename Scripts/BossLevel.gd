extends "res://Scripts/Niveau.gd"


# Declare member variables here. Examples:
var mem_hauteur = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Ambiance").stream_paused = true


func _physics_process(delta):
	if !get_node("Apical"):
		if get_node("Joueur").is_on_floor && !mem_hauteur:
			get_node("FinNiveau").position = Vector2(0, get_node("Joueur").position.y)
			mem_hauteur = true
			
