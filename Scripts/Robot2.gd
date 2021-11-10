extends "res://Scripts/Robot.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	self.detection_joueur()
	if self.detection_joueur && !self.mort:
		if self.cooldownDeTir.is_stopped():
			self.tourner_vers_joueur()
			self.robot_tirer(self.sens)
		else:
			self.vitesse_ennemi = 1
			self.tourner_vers_joueur()
			self.robot_marcher(self.sens)
	elif !self.mort:
		self.robot_marcher(self.sens)
		


func _on_TimerBouger_timeout():
	if !self.detection_joueur && !self.mort:
		if self.sens:
			self.sens = false
		else:
			self.sens = true
