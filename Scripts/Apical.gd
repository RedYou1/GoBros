extends "res://Scripts/EnemyDeBase.gd"


# Declare member variables here. Examples:
const balleApical = preload("res://Scenes/BalleApical.tscn")
var depart_niveau = -368
var fin_niveau = 368
export(float) var profondeur_marteau = 3
var hauteur = 0
var memoire_hauteur = false
var mouvement_haut = 0
var mouvement_cote = 0
var bloc = 0
var marteau = false
var marteau_fait = false
var mem_vitesse
var phase = 1
var vitesse_rotation = 0
var dash = false
var dash_ok = false
export(float) var vitesse_marteau
export(float) var vitesse_dash

func tirer_apical():
	var balle = balleApical.instance()
	if tir:
		balle.directionX = balle.vitesse
		balle.position = position + Vector2(0,30)
		if get_node("../Joueur"):
			balle.look_at(get_node("../Joueur").position)
		get_parent().add_child(balle)
		tir = false
		cooldownDeTir.start(temps_tir)

func bouger_apical():
	collision_mouvement = move_and_collide(Vector2(mouvement_cote,mouvement_haut))
	if collision_mouvement:
		if collision_mouvement.collider.has_method("hit"):
			collision_mouvement.collider.hit(self,damage)

func dash_apical(delta):
	if !memoire_hauteur:
		if get_node("../Joueur"):
			if get_node("../Joueur").is_on_floor:
				hauteur = get_node("../Joueur").position.y - 20
				memoire_hauteur = true
	if !dash:
		if sens:
			if position.x > depart_niveau - vitesse_ennemi:
				mouvement_cote = -vitesse_ennemi
			elif position.x > depart_niveau + vitesse_ennemi:
				mouvement_cote = vitesse_ennemi
			else:
				mouvement_cote = 0
		else:
			if position.x > fin_niveau - vitesse_ennemi:
				mouvement_cote = -vitesse_ennemi
			elif position.x > fin_niveau + vitesse_ennemi:
				mouvement_cote = vitesse_ennemi
			else:
				mouvement_cote = 0
				
		if position.y < hauteur:
			mouvement_haut = vitesse_ennemi
		elif mouvement_cote == 0:
			dash = true
		bouger_apical()
	else:
		mouvement_haut = 0
		if sens:
			animation.rotation += vitesse_rotation
		else:
			animation.rotation -= vitesse_rotation
		if !dash_ok:
			vitesse_rotation += delta/2
			if vitesse_rotation > 0.5:
				dash_ok = true
		else:
			if sens:
				mouvement_cote = vitesse_dash
				if position.x < fin_niveau:
					bouger_apical()
					if collision_mouvement:
						if collision_mouvement.get_collider().name == "Joueur":
							set_collision_layer_bit(3, false)
				else:
					self.collision_mask = 1
					vitesse_ennemi = mem_vitesse
					dash_ok = false
					phase = 0
					sens = false
					vitesse_rotation = 0
			else:
				mouvement_cote = -vitesse_dash
				if position.x > depart_niveau:
					bouger_apical()
					if collision_mouvement:
						if collision_mouvement.get_collider().name == "Joueur":
							set_collision_layer_bit(3, false)
				else:
					set_collision_layer_bit(3, true)
					sens = true
					vitesse_ennemi = mem_vitesse
					dash_ok = false
					dash = false
					vitesse_rotation = 0
	
	
func marteau_apical():
	if !marteau:
		var position_prochain_bloc
		position_prochain_bloc = 64*bloc + depart_niveau
		print(position_prochain_bloc)
		print(position)
		if !memoire_hauteur:
			if get_node("../Joueur"):
				if get_node("../Joueur").is_on_floor:
					hauteur = get_node("../Joueur").position.y - 75
					memoire_hauteur = true
		if position.y < hauteur -vitesse_ennemi:
			mouvement_haut = vitesse_ennemi
		elif position.y > hauteur + vitesse_ennemi:
			mouvement_haut = -vitesse_ennemi
		else:
			mouvement_haut = 0
		if position.x < position_prochain_bloc:
			mouvement_cote = vitesse_ennemi
		elif mouvement_haut == 0:
			marteau = true
		bouger_apical()
	else:
		if !marteau_fait:
			vitesse_ennemi = vitesse_marteau
			mouvement_cote = 0
			mouvement_haut = vitesse_ennemi
			if position.y < hauteur + profondeur_marteau*32 + 16:
				bouger_apical()
				if collision_mouvement:
					if collision_mouvement.get_collider().name == "Joueur":
						set_collision_layer_bit(3, false)
			else:
				marteau_fait = true
		else: 
			vitesse_ennemi = mem_vitesse
			mouvement_haut = -vitesse_ennemi
			if position.y > hauteur:
				bouger_apical()
			else:
				marteau = false
				marteau_fait = false
				set_collision_layer_bit(3, true)
				bloc+=1
	if bloc >11:
		sens = true
		bloc = 0
		phase = 2
		memoire_hauteur = false
		sens = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.damage = 5
	mem_vitesse = vitesse_ennemi


func _physics_process(delta):
	if phase == 1:
		marteau_apical()
	elif phase == 2:
		dash_apical(delta)
