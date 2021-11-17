extends "res://Scripts/Robot.gd"

# Declare member variables here. Examples:
const balleAraignee = preload("res://Scenes/BalleAraignee.tscn")
	
func araignee_tirer(sens):
	if self.tir && self.is_on_floor:
		
		var balle = balleAraignee.instance()
		if self.animation.flip_h:
			balle.directionX = balle.vitesse
			balle.position = position + Vector2(-ballePositionDroit.x, ballePositionDroit.y)
		else:
			balle.directionX = -balle.vitesse
			balle.position = position + Vector2(ballePositionDroit.x, ballePositionDroit.y)
		#self.animation.position = position_marche
		if self.animation.animation != "tirer":
			self.animation.animation = "tirer"
			self.animation.frame = 0
		elif self.animation.frame == 28:
			son_tir = true
			get_node("SonTir").play()
			get_parent().add_child(balle)
		elif self.animation.frame == 59:
			self.tir = false
			self.animation.animation = "idle"
			self.cooldownDeTir.start(temps_tir)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.tourner(sens)

func _physics_process(delta):
	self.fonction_detection_blocage()
	self.fonction_detection_vide()
	if self.detection_joueur && !self.mort:
		if self.tir:
			araignee_tirer(self.sens)
		else:
			self.tourner_vers_joueur()
			self.robot_suivre_joueur()
	elif !self.mort:
		self.robot_bouger_standard()

