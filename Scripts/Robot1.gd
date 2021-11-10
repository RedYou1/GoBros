extends "res://Scripts/Robot.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	if self.detection_joueur && !self.mort:
		self.tourner_vers_joueur()
		self.robot_tirer(self.sens)
