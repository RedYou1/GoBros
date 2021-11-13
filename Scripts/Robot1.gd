extends "res://Scripts/Robot.gd"


# Declare member variables here. Examples:
var repli = false
export(int) var distance_repli
var mem_vitesse = false
var distance_joueur = 0
var mem_val_vitesse

func repli(sens):
	if get_parent().get_node("Joueur"):
		distance_joueur = get_parent().get_node("Joueur").position.x - position.x
		if distance_joueur < 0:
			distance_joueur *= -1
		
		var sens_contraire_joueur
		self.tourner_vers_joueur()
		if self.sens:
			sens_contraire_joueur = false
		else:
			sens_contraire_joueur = true
			
		if distance_joueur < distance_repli:
			if get_node("DetectionRepli").get_collider():
				if get_node("DetectionRepli").get_collider().is_in_group("Block"):
					repli = true
		elif self.is_on_floor:
			repli = false
	
		if repli:
			if !mem_vitesse:
				mem_vitesse = true
				self.vitesse_ennemi *=5
			self.robot_sauter(sens_contraire_joueur)
		elif self.is_on_floor:
			mem_vitesse = false
			self.vitesse_ennemi = mem_val_vitesse
	
# Called when the node enters the scene tree for the first time.
func _ready():
	mem_val_vitesse = self.vitesse_ennemi

func _physics_process(delta):
	if self.sens:
		get_node("DetectionRepli").position.x = 145
	else:
		get_node("DetectionRepli").position.x = -145
	self.fonction_detection_blocage()
	self.fonction_detection_vide()
	
	if self.detection_joueur && !self.mort:
		repli(self.sens)
		if !repli:
			self.robot_suivre_joueur()
	elif !self.mort:
		self.robot_bouger_standard()
