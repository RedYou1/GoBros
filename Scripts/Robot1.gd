extends "res://Scripts/Robot.gd"


# Declare member variables here. Examples:
var repli = false
export(int) var distance_repli
var mem_vitesse = false
var distance_joueur = 0

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
		
		if distance_joueur < distance_repli || !self.is_on_floor:
			repli = true
			self.robot_sauter(sens_contraire_joueur)
		else:
			repli = false
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	self.set_raycast()
	self.fonction_detection_blocage()
	self.fonction_detection_vide()
	if self.detection_joueur && !self.mort:
		if !mem_vitesse:
			mem_vitesse = true
			self.vitesse_ennemi *=5
		
		repli(self.sens)
		if !repli:
			self.tourner_vers_joueur()
			if self.tir:
				self.robot_tirer(self.sens)
			else:
				self.immobile()
	elif !self.mort:
		self.fonction_detection_joueur()
		if self.detection_mur && self.is_on_floor:
			if self.sens:
				self.sens = false
				self.robot_marcher(self.sens)
			else:
				self.sens = true
				self.robot_marcher(self.sens)
			self.set_raycast()
			get_node("TimerBouger").start()
		elif self.detection_blocage && self.is_on_floor:
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
		
