extends "res://Scripts/Personnage.gd"


# Declare member variables here. Examples:
export(float) var vitesse_ennemi = 1
export (int) var distance_detection = 100
export(int) var damage = 1
var sens = false
var barre_vie
var collision_mouvement
var raycast
var detection_joueur = false
export (float) var temps_detection = 15

func set_raycast():
	if self.sens:
		if est_tourne_vers_joueur():
			raycast.cast_to.x = distance_detection
			raycast.look_at(get_node("../Joueur").position)
		else:
			raycast.cast_to.x = -distance_detection
			raycast.rotation = 0
	else:
		raycast.cast_to.x = distance_detection
		if est_tourne_vers_joueur():
			raycast.look_at(get_node("../Joueur").position)
		else:
			raycast.rotation = 0
		

func standard_hit(collider, damage):
	if (collider.is_in_group("Balle") || collider.is_in_group("Joueur")) && !self.mort:
		vie -= damage
		if vie <= 0:
			self.mort = true
	

func _ready():
	barre_vie = get_node("Vie")
	barre_vie.max_value = self.vie_max
	raycast = get_node("DetectionAvant")
	get_node("TimerDetectionJoueur").wait_time = temps_detection
	detection_joueur = false

func sauter():
	if self.is_on_floor:
		self.velocityY = -15
		
func bouger(sens):
	self.tourner(sens)
	if sens:
		collision_mouvement = move_and_collide(Vector2(-vitesse_ennemi,0))
	else:
		collision_mouvement = move_and_collide(Vector2(vitesse_ennemi,0))
	if collision_mouvement:
		if collision_mouvement.collider.has_method("hit"):
			if collision_mouvement.collider.name == "Joueur":
				collision_mouvement.collider.hit(self,damage)

func immobile():
	move_and_collide(Vector2(0,0))

func tourner(sens):
	if self.is_in_group("Araignee"):
		if sens:
			self.animation.flip_h = false
		else:
			self.animation.flip_h = true
	else:
		if sens:
			self.animation.flip_h = true
		else:
			self.animation.flip_h = false

func fonction_detection_joueur():
	if get_node("DetectionAvant").get_collider():
		if get_node("DetectionAvant").get_collider().name == "Joueur":
			detection_joueur = true
			get_node("TimerDetectionJoueur").start()

func tourner_vers_joueur():
	if get_parent().get_node("Joueur"):
		if get_parent().get_node("Joueur").position.x > self.position.x:
			sens = false
		else:
			sens = true
		
func est_tourne_vers_joueur():
	if get_parent().get_node("Joueur"):
		if get_parent().get_node("Joueur").position.x > self.position.x && sens == false:
			return true
		else:
			return false
	else:
		return false

func _physics_process(delta):
	barre_vie.value = self.vie
	set_raycast()
	self.fonction_detection_joueur()



func _on_coolDownDeTir_timeout():
	print("tir ok ennemi")
	tir = true


func _on_TimerDetectionJoueur_timeout():
	detection_joueur = false
