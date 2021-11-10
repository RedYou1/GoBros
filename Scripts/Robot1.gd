extends "res://Scripts/Robot.gd"


# Declare member variables here. Examples:
var repli = false
export(int) var distance_repli

func repli(sens):
	if get_parent().get_node("Joueur"):
		var distance_joueur = get_parent().get_node("Joueur").position.x - position.x
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
	if self.detection_joueur && !self.mort:
		self.vitesse_ennemi *=5
		repli(self.sens)
		if !repli:
			self.tourner_vers_joueur()
			#if self.cooldownDeTir.is_stopped():
			#	self.robot_tirer(self.sens)
			#else:
			self.immobile()
	else:
		self.robot_marcher(self.sens)
		


func _on_TimerBouger_timeout():
	if !self.detection_joueur && !self.mort:
		if self.sens:
			self.sens = false
		else:
			self.sens = true
		
