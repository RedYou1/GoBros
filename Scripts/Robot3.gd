extends "res://Scripts/Robot.gd"

var dash_ok = false
var dash_fini = true
export(float) var temps_avant_dash = 3
var timer_dash
var position_dash = Vector2(99999,99999)
var mem_timer = false
export(float) var temps_du_dash = 0.1
var timer_du_dash
var mem_modulate_g

func dash(delta):
	if dash_ok:
		self.modulate.g = mem_modulate_g
		
		if !dash_fini:
			print("en train de dasher")
			self.robot_marcher(self.sens)
			
	else:
		self.immobile()
		if !mem_timer:
			mem_timer = true
			timer_dash.start()
		self.modulate.g -= delta / timer_dash.wait_time

# Called when the node enters the scene tree for the first time.
func _ready():
	timer_dash = get_node("TimerDash")
	mem_modulate_g = self.modulate.g
	timer_du_dash = get_node("TimerDureeDash")
	self.detection_joueur

func _physics_process(delta):
	if self.detection_joueur && !self.mort:
		if !dash_ok:
			self.tourner_vers_joueur()
		dash(delta)
	elif !self.mort:
		self.fonction_detection_joueur()
		self.immobile()


func _on_TimerDash_timeout():
	print("dash")
	dash_fini = false
	dash_ok = true
	timer_du_dash.start(temps_du_dash)


func _on_TimerDureeDash_timeout():
	dash_ok = false
	dash_fini = true
	timer_dash.start(temps_avant_dash)
