extends "res://Scripts/Personnage.gd"

export(float) var vitesse = 2
export(float) var recovery_time = 2
var in_recovery  = false
export(int) var damage = 1
var barre_vie
var detection_bloc
var bloc_detecte = false
var collision_mouvement
var mem_modulate

func gerer_recovery():
	if in_recovery:
		self.get_node("AnimatedSprite").modulate.a = 0.5
	else:
		self.animation.modulate = mem_modulate

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
	self.cooldownDeTir.wait_time = self.cooldown_de_tir
	get_node("TimerRecovery").wait_time = recovery_time
	mem_modulate = self.animation.modulate


func hit(collider, damage):
	print(collider.name)
	if !in_recovery:
		if collider.is_in_group("Robot") && ! self.mort:
			in_recovery = true
			get_node("TimerRecovery").start()
			vie -= damage
			barre_vie.value = vie
			if vie <= 0:
				self.mort = true
		if collider.is_in_group("Balle") && ! self.mort:
			in_recovery = true
			get_node("TimerRecovery").start()
			vie -= damage
			barre_vie.value = vie
			if vie <= 0:
				self.mort = true

func tirer(dir_balle):
		
	if self.tir:
		var balle = self.balleScene.instance()
		
		if dir_balle == "haut":
			balle.directionY = -balle.vitesse
			balle.position = position + ballePositionHaut
			
		elif dir_balle == "bas":
			balle.directionY = +balle.vitesse
			balle.position = position + ballePositionBas
			
		elif dir_balle == "droit" && animation.flip_h:
			balle.directionX = -balle.vitesse
			balle.position = position + Vector2(-ballePositionDroit.x, ballePositionDroit.y)
			
		elif dir_balle == "droit" && !animation.flip_h:
			balle.directionX = +balle.vitesse
			balle.position = position + Vector2(ballePositionDroit.x, ballePositionDroit.y)
			
		get_parent().add_child(balle)
		self.cooldownDeTir.start()
		self.tir = false

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

func gestion_collision():
	if collision_mouvement:
		if collision_mouvement.collider.has_method("hit"):
			if collision_mouvement.collider.is_in_group("EnnemyDeBase"):
				collision_mouvement.collider.hit(self,damage)

func _physics_process(delta):
	set_detection_bloc()
	gerer_recovery()
	
	if !self.mort:
		
		set_animation()
	
		if Input.is_action_pressed("DROIT"):
			collision_mouvement = move_and_collide(Vector2(vitesse,0))
		
		elif Input.is_action_pressed("GAUCHE"):
			collision_mouvement = move_and_collide(Vector2(-vitesse,0))
			
		if Input.is_action_pressed("HAUT") && bloc_detecte:
			self.velocityY = -vitesse
	
		if Input.is_action_just_pressed("SAUT") and self.is_on_floor:
			self.velocityY = -15
	
		if Input.is_action_pressed("TIRER"):
			if Input.is_action_pressed("DROIT") || Input.is_action_pressed("GAUCHE"):
				self.tirer("droit")
			elif Input.is_action_pressed("BAS"):
				tirer("bas")
			elif Input.is_action_pressed("HAUT"):
				tirer("haut")
			else:
				tirer("droit")
			
		if Input.is_action_just_released("TIRER"):
			self.tir = false


func _on_TimerRecovery_timeout():
	in_recovery = false
