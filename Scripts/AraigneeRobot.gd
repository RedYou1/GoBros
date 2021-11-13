extends "res://Scripts/Robot.gd"

# Declare member variables here. Examples:
const balleAraignee = preload("res://Scenes/BalleAraignee.tscn")
export (float) var vitesse_course = 1.5
	
func araignee_tirer(sens):
	self.tourner(sens)
	if self.tir && self.is_on_floor:
		print(self.cooldownDeTir.time_left)
		
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
			get_parent().add_child(balle)
		elif self.animation.frame == 59:
			self.tir = false
			self.animation.animation = "idle"
			self.cooldownDeTir.start(temps_tir)

# Called when the node enters the scene tree for the first time.
func _ready():
	vitesse_ennemi
	self.tourner(sens)

func _physics_process(delta):
	self.fonction_detection_blocage()
	self.fonction_detection_vide()
	if self.detection_joueur && !self.mort:
		if self.tir:
			araignee_tirer(self.sens)
		else:
			self.robot_suivre_joueur()
	elif !self.mort:
		self.robot_bouger_standard()

