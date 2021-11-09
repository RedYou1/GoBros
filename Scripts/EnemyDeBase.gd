extends "res://Scripts/Personnage.gd"


# Declare member variables here. Examples:
export(float) var vitesse_ennemi = 2
var collision
var sens = false

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

func immobile():
	move_and_collide(Vector2(0,0))

func tourner(sens):
	if sens:
		self.animation.flip_h = true
	else:
		self.animation.flip_h = false

func tourner_vers_joueur():
	if get_parent().get_node("Joueur"):
		if get_parent().get_node("Joueur").position.x > self.position.x:
			sens = false
		else:
			sens = true
		self.tourner(sens)
		

