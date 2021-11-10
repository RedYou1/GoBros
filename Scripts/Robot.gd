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
	self.tourner(true)
		
	if self.tir and self.cooldownDeTir.is_stopped():
		var balle = self.balleScene.instance()
		
		if self.animation.flip_h:
			balle.direction *= -1
			balle.position = position - self.ballePositionDroit
		else:
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
			self.animation.animation = "idle"
			self.cooldownDeTir.start(cooldown_de_tir)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	raycast = get_node("DetectionAvant")
	self.animation.animation = "idle"
	

func _physics_process(delta):
	if get_node("DetectionAvant").get_collider() && !detection_joueur:
		if get_node("DetectionAvant").get_collider().name == "Joueur":
			detection_joueur = true
