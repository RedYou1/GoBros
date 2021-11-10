extends "res://Scripts/Personnage.gd"

export(float) var vitesse = 2
var barre_vie
var detection_bloc
var bloc_detecte = false

func set_detection_bloc():
	if self.animation.flip_h:
		detection_bloc.cast_to.x = -10
	else:
		detection_bloc.cast_to.x = 10
	if detection_bloc.get_collider():
		if detection_bloc.get_collider().is_in_group("Block"):
			bloc_detecte = true
		else:
			bloc_detecte = false
	else:
		bloc_detecte = false

func _ready():
	barre_vie = get_node("Vie")
	barre_vie.max_value = self.vie_max
	barre_vie.value = vie
	detection_bloc = get_node("DetectionBloc")


func hit(collider, damage):
	if (collider.is_in_group("EnnemyDeBase") || collider.is_in_group("Balle")) && ! self.mort:
		vie -= damage
		barre_vie.value = vie
		if vie <= 0:
			self.mort = true

func tirer(dir_balle):
		
	if tir and self.cooldownDeTir.is_stopped():
		var balle = self.balleScene.instance()
		
		if dir_balle == "haut":
			balle.directionY = -balle.vitesse
			balle.position = position + ballePositionHaut
			get_parent().add_child(balle)
			self.cooldownDeTir.start(self.cooldown_de_tir)
			
		elif dir_balle == "bas" && !is_on_floor:
			balle.directionY = +balle.vitesse
			balle.position = position + ballePositionBas
			get_parent().add_child(balle)
			self.cooldownDeTir.start(self.cooldown_de_tir)
			
		elif dir_balle == "droit" && animation.flip_h:
			balle.directionX = -balle.vitesse
			balle.position = position + Vector2(-ballePositionDroit.x, ballePositionDroit.y)
			get_parent().add_child(balle)
			self.cooldownDeTir.start(self.cooldown_de_tir)
			
		elif dir_balle == "droit" && !animation.flip_h:
			balle.directionX = +balle.vitesse
			balle.position = position + Vector2(ballePositionDroit.x, ballePositionDroit.y)
			get_parent().add_child(balle)
			self.cooldownDeTir.start(self.cooldown_de_tir)

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
	set_detection_bloc()
	
	if !self.mort:
		
		set_animation()
	
		if Input.is_action_pressed("DROIT"):
			move_and_collide(Vector2(vitesse,0))
		
		elif Input.is_action_pressed("GAUCHE"):
			move_and_collide(Vector2(-vitesse,0))
			
		if Input.is_action_pressed("HAUT") && bloc_detecte:
			self.velocityY = -vitesse
	
		if Input.is_action_just_pressed("SAUT") and self.is_on_floor:
			self.velocityY = -15
	
		if Input.is_action_pressed("TIRER"):
			if Input.is_action_pressed("DROIT") || Input.is_action_pressed("GAUCHE"):
				self.tir = true
				self.tirer("droit")
			elif Input.is_action_pressed("BAS") && !self.is_on_floor:
				self.tir = true
				tirer("bas")
			elif Input.is_action_pressed("HAUT"):
				self.tir = true
				tirer("haut")
			else:
				self.tir = true
				tirer("droit")
			
		if Input.is_action_just_released("TIRER"):
			self.tir = false
