extends "res://Scripts/Personnage.gd"


# Declare member variables here. Examples:
export(float) var vitesse_ennemi = 1
export(float) var tir_ennemi = 1
export(int) var damage = 1
var sens = false
var barre_vie
var collision_mouvement
var cooldownDeTir
var tir = false



func standard_hit(collider, damage):
	if (collider.is_in_group("Balle") || collider.is_in_group("Joueur")) && !self.mort:
		vie -= damage
		if vie <= 0:
			self.mort = true
	

func _ready():
	barre_vie = get_node("Vie")
	barre_vie.max_value = self.vie_max
	cooldownDeTir = get_node("coolDownDeTir")
	cooldownDeTir.wait_time = tir_ennemi

func sauter():
	if self.is_on_floor:
		self.velocityY = -15
		
func bouger(sens):
	if sens:
		self.animation.flip_h = true
		collision_mouvement = move_and_collide(Vector2(-vitesse_ennemi,0))
	else:
		self.animation.flip_h = false
		collision_mouvement = move_and_collide(Vector2(vitesse_ennemi,0))
	if collision_mouvement:
		if collision_mouvement.collider.has_method("hit"):
			if collision_mouvement.collider.name == "Joueur":
				collision_mouvement.collider.hit(self,damage)

func immobile():
	move_and_collide(Vector2(0,0))

func tourner(sens):
	if sens:
		self.animation.flip_h = true
	else:
		self.animation.flip_h = false

func tourner_vers_joueur():
	if get_parent().get_node("Joueur"):
		if get_parent().get_node("Joueur").position.x > self.position.x:
			sens = false
		else:
			sens = true
		self.tourner(sens)

func _physics_process(delta):
	barre_vie.value = self.vie



func _on_coolDownDeTir_timeout():
	print("tir ok ennemi")
	tir = true
