extends "res://Scripts/Robot.gd"

var dash_ok = false
var dash_fini
export(float) var temps_avant_dash
var timer_dash
var position_dash = Vector2(99999,99999)
var mem_timer = false
export(float) var temps_du_dash
var timer_du_dash
var mem_modulate_g

func dash(delta):
	if dash_ok:
		print("dash_ok")
		self.modulate.g = mem_modulate_g
		timer_du_dash.start(temps_du_dash)
		
		if dash_fini:
			self.robot_marcher(self.sens)
		else:
			dash_ok = false
			dash_fini = false
			timer_dash.start(temps_avant_dash)
			
	else:
		print("!dash_ok")
		self.immobile()
		if !mem_timer:
			mem_timer = true
			print("start timer")
			timer_dash.start(temps_avant_dash)
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
		fonction_detection_joueur()
		self.immobile()


func _on_TimerDash_timeout():
	dash_ok = true


func _on_TimerDureeDash_timeout():
	print("dash fini")
	dash_fini = true
