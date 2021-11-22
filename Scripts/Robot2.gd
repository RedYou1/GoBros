extends "res://Scripts/Robot.gd"


# Declare member variables here. Examples:


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	self.fonction_detection_vide()
	self.fonction_detection_blocage()
	
	if self.detection_joueur && !self.mort:
		if self.tir:
			self.tourner_vers_joueur()
			self.robot_tirer(self.sens)
		else:
			self.robot_suivre_joueur()
	elif !self.mort:
		self.robot_bouger_standard()
		


func _on_TimerBouger_timeout():
	if !self.detection_joueur && !self.mort:
		if self.sens:
			self.sens = false
		else:
			self.sens = true
