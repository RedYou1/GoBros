extends "res://Scripts/Robot.gd"

var dash_ok = false
var dash_fini = true
export(float) var temps_avant_dash = 3
export(int) var vitesse_dash = 15
var timer_dash
var position_dash = Vector2(99999,99999)
var mem_timer = false
var mem_val_vitesse
export(float) var temps_du_dash = 0.1
var timer_du_dash
var mem_modulate_r
var son_dash = false

#Fonction pour le dash du robot 3
#param delta: pour gérer la vitesse des animations
func dash(delta):
	#Si c'est le temps de dasher, on remet la couleur correct et on dash pendant le temps de dash
	#Le dash s'arrête si on collisionne le joueur
	if dash_ok:
		self.animation.modulate.r = mem_modulate_r
		self.vitesse_ennemi = vitesse_dash
		if !dash_fini && !detection_vide:
			son_dash = true
			get_node("SonDash").play()
			self.robot_marcher(self.sens)
			if collision_mouvement:
				if collision_mouvement.collider.name == "Joueur" || detection_blocage:
					dash_ok = false
					dash_fini = true
					timer_dash.start(temps_avant_dash)
		#S'il y a du vide devant le robot quand il s'Apprête à dasher, il tire à la place
		elif detection_vide:
			self.robot_tirer(self.sens)
			if !self.tir:
				dash_ok = false
				dash_fini = true
				timer_dash.start(temps_avant_dash)
	#Le robot suit le joueur en attendant de dasher
	else:
		self.vitesse_ennemi = mem_val_vitesse
		self.robot_suivre_joueur()
		if !mem_timer:
			mem_timer = true
			timer_dash.start()
		self.animation.modulate.r = 90 / ((get_node("TimerDash").time_left*100) / get_node("TimerDash").wait_time)

# Called when the node enters the scene tree for the first time.
func _ready():
	timer_dash = get_node("TimerDash")
	mem_modulate_r = self.animation.modulate.r
	timer_du_dash = get_node("TimerDureeDash")
	self.detection_joueur
	mem_val_vitesse = self.vitesse_ennemi

#Fonction principale
func _physics_process(delta):
	#Gestion des détections avec raycast
	self.fonction_detection_vide()
	self.fonction_detection_blocage()
	
	#Pattern du robot 3
	if self.detection_joueur && !self.mort:
		if !dash_ok:
			self.tourner_vers_joueur()
		dash(delta)
	elif !self.mort:
		self.vitesse_ennemi = mem_val_vitesse
		self.animation.modulate.r = mem_modulate_r
		self.robot_bouger_standard()
	
	#Gestion du son du dash
	if son_dash:
		get_node("SonDash").stream_paused = false
		if get_node("SonDash").get_playback_position() >= get_node("SonDash").stream.get_length() - 0.05:
			son_dash = false
	else:
		get_node("SonDash").stream_paused = true
		get_node("SonDash").play()

#Timer entre les dash
func _on_TimerDash_timeout():
	dash_fini = false
	dash_ok = true
	if !self.detection_vide:
		timer_du_dash.start(temps_du_dash)

#Timer du dash
func _on_TimerDureeDash_timeout():
	dash_ok = false
	dash_fini = true
	timer_dash.start(temps_avant_dash)
