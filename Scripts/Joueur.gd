extends "res://Scripts/Personnage.gd"

func _process(delta):
	
	if Input.is_action_pressed("DROIT"):
		self.bouger(1)
	if Input.is_action_pressed("GAUCHE"):
		self.bouger(-1)
	
	if Input.is_action_pressed("HAUT") and self.is_on_floor:
		self.sauter()
	
	if Input.is_action_just_pressed("TIRER"):
		self.tir = true
		self.tirer()
	if Input.is_action_just_released("TIRER"):
		self.tir = false
