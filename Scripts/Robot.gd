extends "res://Scripts/EnemyDeBase.gd"


# Declare member variables here. Examples:
export (int) var ajustement_saut
export (int) var ajustement_marche
export (int) var distance_detection = 100
export (float) var temps_detection = 15

var raycast
var detection_joueur = false
var detection_vide = false
var detection_blocage = false
var detection_mur = false
var position_base
var position_saut
var position_marche

func robot_suivre_joueur():
	self.fonction_detection_joueur()
	self.tourner_vers_joueur()
	if self.detection_mur && self.detection_blocage && self.is_on_floor:
		self.immobile()
	elif self.detection_blocage && !self.detection_mur && self.is_on_floor:
		self.robot_sauter(self.sens)
	else:
		if self.detection_vide && self.is_on_floor:
			self.immobile()
		else:
			self.robot_marcher(self.sens)
	

func robot_bouger_standard():
	self.fonction_detection_joueur()
		
	if self.detection_mur && self.detection_blocage && self.is_on_floor:
		if self.sens:
			self.sens = false
			self.robot_marcher(self.sens)
		else:
			self.sens = true
			self.robot_marcher(self.sens)
		get_node("TimerBouger").start()
		
	elif self.detection_blocage && !self.detection_mur && self.is_on_floor:
		self.robot_sauter(self.sens)
		get_node("TimerBouger").start()
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
			
func hit(collider, damage):
	self.standard_hit(collider, damage)
	if (collider.is_in_group("Joueur") || collider.is_in_group("Balle")) && ! self.mort:
		detection_joueur = true

func robot_sauter(sens):
	if self.is_on_floor:
		#self.animation.position = position_saut
		if self.animation.animation != "sauter":
			self.animation.animation = "sauter"
			self.animation.frame = 0
		
		elif self.animation.frame == 3:
			self.sauter()
	else:
		self.bouger(sens)
		#self.animation.position = position_base
			
	
func robot_marcher(sens):
	self.bouger(sens)
	#self.animation.position = position_marche
	self.animation.animation = "marcher"
	
func robot_tirer(sens):
	self.tourner(sens)
	if self.tir && self.is_on_floor:
		var balle = self.balleScene.instance()
		self.tir = true
		if self.animation.flip_h:
			balle.directionX = -balle.vitesse
			balle.position = position - ballePositionDroit
		else:
			balle.directionX = balle.vitesse
			balle.position = position + ballePositionDroit
		#self.animation.position = position_marche
		
		if self.animation.animation != "tirer":
			self.animation.animation = "tirer"
			self.animation.frame = 0
		elif self.animation.frame == 5:
			get_parent().add_child(balle)
		elif self.animation.frame == 12:
			get_parent().add_child(balle)
		elif self.animation.frame == 17:
			self.tir = false
			self.animation.animation = "idle"
			self.cooldownDeTir.start()
	#else:
		#self.animation.position = position_base

func immobile():
	self.animation.animation = "idle"
	#self.animation.position = position_base
# Called when the node enters the scene tree for the first time.
func _ready():
	raycast = get_node("DetectionAvant")
	self.animation.animation = "idle"
	get_node("TimerDetectionJoueur").wait_time = temps_detection
	position_saut = self.animation.position + Vector2(0, -ajustement_saut)
	position_marche = self.animation.position + Vector2(0, -ajustement_marche)
	position_base = self.animation.position
	
func set_raycast():
	if self.sens:
		raycast.cast_to.x = -distance_detection
		get_node("DetectionBlocAvant").cast_to.x = -20
		get_node("DetectionBlocHaut").cast_to.x = -30
		get_node("DetectionVide").position = Vector2(-13, 11)
	else:
		raycast.cast_to.x = distance_detection
		get_node("DetectionBlocAvant").cast_to.x = 20
		get_node("DetectionBlocHaut").cast_to.x = 30
		get_node("DetectionVide").position = Vector2(13, 11)
	

func fonction_detection_joueur():
	if get_node("DetectionAvant").get_collider():
		if get_node("DetectionAvant").get_collider().name == "Joueur":
			detection_joueur = true
			get_node("TimerDetectionJoueur").start()
			
func fonction_detection_vide():
	if get_node("DetectionVide").get_collider() && self.is_on_floor:
		if get_node("DetectionVide").get_collider().is_in_group("Block"):
			detection_vide = false
		else:
			detection_vide = true
	else:
		detection_vide = true
		
func fonction_detection_blocage():
	if get_node("DetectionBlocAvant").get_collider() && self.is_on_floor:
		if get_node("DetectionBlocAvant").get_collider().is_in_group("Block") && self.is_on_floor:
			detection_blocage = true
		else:	
			detection_blocage = false
	else:
		detection_blocage = false
	if get_node("DetectionBlocHaut").get_collider() && self.is_on_floor:
		if get_node("DetectionBlocHaut").get_collider().is_in_group("Block") && self.is_on_floor:
			detection_mur = true
		else:	
			detection_mur = false
	else:
		detection_mur = false



func _on_TimerDetectionJoueur_timeout():
	detection_joueur = false
