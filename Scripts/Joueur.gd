extends "res://Scripts/Personnage.gd"

func _process(delta):
	
	if Input.is_action_pressed("DROIT"):
		move_and_collide(Vector2(self.vitesse,0))
		self.animation.flip_h = false
	if Input.is_action_pressed("GAUCHE"):
		move_and_collide(Vector2(-self.vitesse,0))
		self.animation.flip_h = true
	
	if Input.is_action_just_pressed("HAUT") and self.is_on_floor:
		self.velocityY = -15
	
	if Input.is_action_just_pressed("TIRER"):
		self.tir = true
		self.tirer()
	if Input.is_action_just_released("TIRER"):
		self.tir = false
