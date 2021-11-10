extends "res://Scripts/EnemyDeBase.gd"


# Declare member variables here. Examples:
export (int) var ajustement_saut
export (int) var ajustement_marche
var raycast
var detection_joueur = false

func hit(collider, damage):
	self.standard_hit(collider, damage)
	if (collider.is_in_group("Joueur") || collider.is_in_group("Balle")) && ! self.mort:
		detection_joueur = true

func robot_sauter(sens):
	if self.is_on_floor:
		self.collision.position.y -= ajustement_saut
		if self.animation.animation != "sauter":
			self.animation.animation = "sauter"
			self.animation.frame = 0
		
		elif self.animation.frame == 3:
			self.sauter()
	else:
		self.bouger(sens)
			
	
func robot_marcher(sens):
	self.bouger(sens)
	self.animation.position.y -= ajustement_marche
	self.animation.animation = "marcher"
	
func robot_tirer(sens):
	self.tourner(sens)
	if self.cooldownDeTir.is_stopped():
		var balle = self.balleScene.instance()
		self.tir = true
		if self.animation.flip_h:
			balle.directionX = -balle.vitesse
			balle.position = position - self.ballePositionDroit
		else:
			balle.directionX = balle.vitesse
			balle.position = position + self.ballePositionDroit
		self.collision.position.y -= ajustement_marche
		
		if self.animation.animation != "tirer":
			self.animation.animation = "tirer"
			self.animation.frame = 0
		elif self.animation.frame == 5:
			get_parent().add_child(balle)
		elif self.animation.frame == 12:
			get_parent().add_child(balle)
		elif self.animation.frame == 17:
			self.tir = false
			self.animation.animation = "idle"
			self.cooldownDeTir.start(self.cooldown_de_tir)

func immobile():
	self.animation.animation = "idle"

# Called when the node enters the scene tree for the first time.
func _ready():
	raycast = get_node("DetectionAvant")
	self.animation.animation = "idle"
	

func detection_joueur():
	if get_node("DetectionAvant").get_collider():
		#print(get_node("DetectionAvant").get_collider().name)
		if get_node("DetectionAvant").get_collider().name == "Joueur":
			detection_joueur = true
