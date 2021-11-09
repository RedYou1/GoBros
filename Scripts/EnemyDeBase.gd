extends "res://Scripts/Personnage.gd"


var collision

func _ready():
	collision = get_node("CollisionShape2D")

