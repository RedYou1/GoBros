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
var mem_modulate_g

func dash(delta):
	if dash_ok:
		self.animation.modulate.g = mem_modulate_g
		self.vitesse_ennemi = vitesse_dash
		if !dash_fini && !detection_blocage && !detection_vide:
			self.robot_marcher(self.sens)
			
	else:
		self.vitesse_ennemi = mem_val_vitesse
		self.robot_suivre_joueur()
		if !mem_timer:
			mem_timer = true
			timer_dash.start()
		self.animation.modulate.g -= delta / timer_dash.wait_time

# Called when the node enters the scene tree for the first time.
func _ready():
	timer_dash = get_node("TimerDash")
	mem_modulate_g = self.animation.modulate.g
	timer_du_dash = get_node("TimerDureeDash")
	self.detection_joueur
	mem_val_vitesse = self.vitesse_ennemi

func _physics_process(delta):
	self.set_raycast()
	self.fonction_detection_vide()
	self.fonction_detection_blocage()
	if self.detection_joueur && !self.mort:
		if !dash_ok:
			self.tourner_vers_joueur()
		dash(delta)
	elif !self.mort:
		self.robot_bouger_standard()


func _on_TimerDash_timeout():
	dash_fini = false
	dash_ok = true
	timer_du_dash.start(temps_du_dash)


func _on_TimerDureeDash_timeout():
	dash_ok = false
	dash_fini = true
	timer_dash.start(temps_avant_dash)
