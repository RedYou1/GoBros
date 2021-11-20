extends "res://Scripts/EnemyDeBase.gd"


# Declare member variables here. Examples:
export (int) var ajustement_saut
export (int) var ajustement_marche

const balleScene = preload("res://Scenes/BalleEnnemi.tscn")
var detection_vide = false
var detection_blocage = false
var detection_mur = false
var position_base
var position_saut
var position_marche
var tir_robot = false

#Fonction pour suivre le joueur standard
func robot_suivre_joueur():
	self.fonction_detection_joueur()
	self.tourner_vers_joueur()
	
	#On saute par dessus les obstacles quand il y en a
	#On bloque quand il y a du vide ou un mur
	if self.detection_mur && self.detection_blocage && self.is_on_floor:
		self.immobile()
	elif self.detection_blocage && !self.detection_mur && self.is_on_floor:
		self.robot_sauter(self.sens)
	else:
		if self.detection_vide && self.is_on_floor:
			self.immobile()
		else:
			self.robot_marcher(self.sens)
	
#Fonction pour faire bouger le robot quand le joueur n'est pas détecté
func robot_bouger_standard():
	self.fonction_detection_joueur()
	
	#On change de sens et on restart le timer pour bouger quand on détecte un mur
	if self.detection_mur && self.detection_blocage && self.is_on_floor:
		if self.sens:
			self.sens = false
			self.robot_marcher(self.sens)
		else:
			self.sens = true
			self.robot_marcher(self.sens)
		get_node("TimerBouger").start()
	#On saute par dessus les obstacles
	elif self.detection_blocage && !self.detection_mur && self.is_on_floor:
		self.robot_sauter(self.sens)
	else:
		#On change de sens et on restart le timer pour bouger quand on détecte du vide
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

#On gère les hit du robot
#param collider: ce qui a fait collision
#param damage: dommages de la collision
func hit(collider, damage):
	self.standard_hit(collider, damage)
	#Si la collision vient du joueur ou d'une balle, le joueur est détecté
	if (collider.name == "Joueur" || collider.is_in_group("Balle")) && ! self.mort && !detection_joueur:
		detection_joueur = true
		self.tourner_vers_joueur()
		self.tourner(self.sens)

#Fonction pour permettre au robot de sauter par dessus les obstacles
#param sens: sens du saut
func robot_sauter(sens):
	if self.is_on_floor:
		#On ajuste l'Animation du robot
		self.animation.position = position_saut
		if self.animation.animation != "sauter":
			self.animation.animation = "sauter"
			self.animation.frame = 0
		#On se synchronise avec l'animation de saut
		elif self.animation.frame == 3:
			self.sauter()
	else:
		self.bouger(sens)
		self.animation.position = position_base
			
#Fonction pour permettre au robot de marcher
#param sens: sens pour marcher
func robot_marcher(sens):
	self.bouger(sens)
	#On ajuste la position de l'animation
	self.animation.position = position_marche
	self.animation.animation = "marcher"

#Fonction pour faire tirer le robot
#param sens: sens pour tirer
func robot_tirer(sens):
	self.tourner(sens)
	if self.tir && self.is_on_floor:
		#On instancie la balle dans la bonne direction
		var balle = self.balleScene.instance()
		if self.animation.flip_h:
			balle.directionX = -balle.vitesse
			balle.position = position - ballePositionDroit
		else:
			balle.directionX = balle.vitesse
			balle.position = position + ballePositionDroit
		#On ajuste la position de l'animation
		self.animation.position = position_marche
		
		#On met l'animation de tir et on se synchronise avec
		if self.animation.animation != "tirer":
			self.animation.animation = "tirer"
			self.animation.frame = 0
		#Première balle
		elif self.animation.frame == 5 && !tir_robot:
			son_tir = true
			get_node("SonTir").play()
			tir_robot = true
			get_parent().add_child(balle)
		#Deuxi;eme balle
		elif self.animation.frame == 12 && !tir_robot:
			son_tir = true
			get_node("SonTir").play()
			tir_robot = true
			get_parent().add_child(balle)
		#Fin du tir
		elif self.animation.frame == 17:
			self.tir = false
			self.animation.animation = "idle"
			self.cooldownDeTir.start()
		#On utilise une autre variable de confirmation pour éviter que le robot tire plusieurs balles
		#le temps d'arriver à une autre frame de l'animation
		elif self.animation.frame != 5 && self.animation.frame != 12:
			tir_robot = false
	else:
		self.animation.position = position_base

#Fonction pour mettre le robot immobile
func immobile():
	self.animation.animation = "idle"
	self.animation.position = position_base
	
# Called when the node enters the scene tree for the first time.
func _ready():
	self.animation.animation = "idle"
	position_saut = self.animation.position + Vector2(0, -ajustement_saut)
	position_marche = self.animation.position + Vector2(0, -ajustement_marche)
	position_base = self.animation.position

#Fonction pour gérer les différents raycasts du robot pour qu'ils soient du bon sens
func robot_set_raycast():
	if self.is_in_group("Araignee"):
		if self.sens:
			get_node("DetectionBlocAvant").cast_to.x = -25
			get_node("DetectionBlocMilieu").cast_to.x = -25
			get_node("DetectionBlocHaut").cast_to.x = -40
			get_node("DetectionVide").position = Vector2(-17, 11)
		else:
			get_node("DetectionBlocAvant").cast_to.x = 25
			get_node("DetectionBlocMilieu").cast_to.x = 25
			get_node("DetectionBlocHaut").cast_to.x = 40
			get_node("DetectionVide").position = Vector2(9, 11)
	else:
		if self.sens:
			get_node("DetectionBlocAvant").cast_to.x = -20
			get_node("DetectionBlocMilieu").cast_to.x = -20
			get_node("DetectionBlocHaut").cast_to.x = -30
			get_node("DetectionVide").position = Vector2(-13, 11)
		else:
			get_node("DetectionBlocAvant").cast_to.x = 20
			get_node("DetectionBlocMilieu").cast_to.x = 20
			get_node("DetectionBlocHaut").cast_to.x = 30
			get_node("DetectionVide").position = Vector2(13, 11)

#Fonction qui gère le raycast de détection du vide
func fonction_detection_vide():
	if get_node("DetectionVide").get_collider() && self.is_on_floor:
		if get_node("DetectionVide").get_collider().is_in_group("Block"):
			detection_vide = false
			get_node("TimerDetectionVide").stop()
		else:
			get_node("TimerDetectionVide").start()
	else:
		get_node("TimerDetectionVide").start()

#Fonction pour détecter les blocages et les murs
func fonction_detection_blocage():
	if self.is_in_group("Araignee"):
		if get_node("DetectionBlocHaut").get_collider() && get_node("DetectionBlocMilieu").get_collider()  && self.is_on_floor:
			if get_node("DetectionBlocHaut").get_collider().is_in_group("Block") && self.is_on_floor:
				detection_mur = true
			else:	
				detection_mur = false
		else:
			detection_mur = false
		if get_node("DetectionBlocAvant").get_collider() && self.is_on_floor:
			if get_node("DetectionBlocAvant").get_collider().is_in_group("Block") && self.is_on_floor:
				detection_blocage = true
			else:	
				detection_blocage = false
		elif get_node("DetectionBlocMilieu").get_collider() && self.is_on_floor:
			if get_node("DetectionBlocMilieu").get_collider().is_in_group("Block") && self.is_on_floor:
				detection_blocage = true
			else:	
				detection_blocage = false
		else:
			detection_blocage = false
	else:
		if get_node("DetectionBlocHaut").get_collider() && get_node("DetectionBlocAvant").get_collider()  && self.is_on_floor:
			if get_node("DetectionBlocHaut").get_collider().is_in_group("Block") && self.is_on_floor:
				detection_mur = true
			else:	
				detection_mur = false
		else:
			detection_mur = false
			
		if get_node("DetectionBlocAvant").get_collider() && self.is_on_floor:
			if get_node("DetectionBlocAvant").get_collider().is_in_group("Block") && self.is_on_floor:
				detection_blocage = true
			else:	
				detection_blocage = false
		else:
			detection_blocage = false

#Timer pour le mouvement du robot quand le joueur n'est pas détecté
func _on_TimerBouger_timeout():
	if !self.detection_joueur && !self.mort:
		if self.sens:
			self.sens = false
		else:
			self.sens = true

#Fonction principale
func _physics_process(delta):
	self.robot_set_raycast()
		


func _on_TimerDetectionVide_timeout():
	detection_vide = true
