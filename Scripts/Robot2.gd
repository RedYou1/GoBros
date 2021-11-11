extends "res://Scripts/Robot.gd"


# Declare member variables here. Examples:


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	self.set_raycast()
	self.fonction_detection_vide()
	self.fonction_detection_blocage()
	
	if self.detection_joueur && !self.mort:
		if self.tir:
			self.tourner_vers_joueur()
			self.robot_tirer(self.sens)
		else:
			if self.detection_blocage && self.is_on_floor:
				self.robot_sauter(self.sens)
			else:
				if self.detection_vide && self.is_on_floor:
					self.immobile()
				else:
					self.robot_marcher(self.sens)
	elif !self.mort:
		self.fonction_detection_joueur()
		
		if self.detection_blocage && self.is_on_floor:
			self.robot_sauter(self.sens)
		else:
			if self.detection_vide && self.is_on_floor:
				if self.sens:
					self.sens = false
					self.robot_marcher(self.sens)
				else:
					self.sens = true
					self.robot_marcher(self.sens)
				get_node("TimerBouger").start()
			else:
				self.robot_marcher(self.sens)
		


func _on_TimerBouger_timeout():
	if !self.detection_joueur && !self.mort:
		if self.sens:
			self.sens = false
		else:
			self.sens = true
