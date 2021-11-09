extends "res://Scripts/Personnage.gd"

export(float) var vitesse = 2
var vie

func set_animation():
	self.animation.playing = true
	
	if !self.is_on_floor:
		if Input.is_action_pressed("TIRER") && Input.is_action_pressed("BAS"):
			if self.animation.animation != "tirer_bas":
				self.animation.animation = "tirer_bas"
		else:
			if self.animation.animation != "sauter":
				self.animation.animation = "sauter"
			if Input.is_action_pressed("DROIT"):
				self.animation.flip_h = false
			elif Input.is_action_pressed("GAUCHE"):
				self.animation.flip_h = true
	
	elif Input.is_action_pressed("DROIT"):
		self.animation.flip_h = false
		if self.animation.animation != "courir":
			self.animation.animation = "courir"
			
	elif Input.is_action_pressed("GAUCHE"):
		self.animation.flip_h = true
		if self.animation.animation != "courir":
			self.animation.animation = "courir"
	
	elif Input.is_action_pressed("TIRER") && Input.is_action_pressed("HAUT"):
		if self.animation.animation != "tirer_haut":
			self.animation.animation = "tirer_haut"
	
	elif Input.is_action_pressed("TIRER"):
		if self.animation.animation != "tirer":
			self.animation.animation = "tirer"
			
	else:
		if self.animation.animation != "idle":
			self.animation.animation = "idle"

func _physics_process(delta):
	set_animation()
	
	if Input.is_action_pressed("DROIT"):
		move_and_collide(Vector2(vitesse,0))
		
	elif Input.is_action_pressed("GAUCHE"):
		move_and_collide(Vector2(-vitesse,0))
	
	if Input.is_action_just_pressed("SAUT") and self.is_on_floor:
		self.velocityY = -15
	
	if Input.is_action_pressed("TIRER"):
		if Input.is_action_pressed("HAUT"):
			self.tir = true
			self.tirer("haut")
		elif Input.is_action_pressed("BAS") && !self.is_on_floor:
			self.tir = true
			self.tirer("bas")
		else:
			self.tir = true
			self.tirer("droit")
			
	if Input.is_action_just_released("TIRER"):
		self.tir = false
