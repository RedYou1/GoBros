extends "res://Scripts/Personnage.gd"


# Declare member variables here. Examples:
export(float) var vitesse_ennemi = 10
var collision

func _ready():
	collision = get_node("CollisionShape2D")

func sauter():
	if self.is_on_floor:
		self.velocityY = -15
		
func bouger(sens):
	if sens:
		self.animation.flip_h = true
		move_and_collide(Vector2(-vitesse_ennemi,0))
	else:
		self.animation.flip_h = false
		move_and_collide(Vector2(vitesse_ennemi,0))
		

