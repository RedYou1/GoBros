extends "res://Scripts/Robot.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#Fonction principale
func _physics_process(delta):
	#On gère la détection des différents raycasts
	self.fonction_detection_vide()
	self.fonction_detection_blocage()
	
	#On gère le pattern du robot 2
	if self.detection_joueur && !self.mort:
		if self.tir:
			self.tourner_vers_joueur()
			self.robot_tirer(self.sens)
		else:
			self.robot_suivre_joueur()
	elif !self.mort:
		self.robot_bouger_standard()
