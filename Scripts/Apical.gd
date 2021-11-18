extends "res://Scripts/EnemyDeBase.gd"

#Balle
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
var phase = 0
var vitesse_rotation = 0
var dash = false
var dash_ok = false
var nb_balles = 0
var position_tir_ok = false
var position_intro_ok = false
var bulle_vue = false
var timer_bulle = false
var mem_mort = false
var mem_vie_basse = false
export(float) var vitesse_marteau
export(float) var vitesse_dash
export(int) var balles_max = 100
var son_ambiance = false


#Fonction pour gérer les dégats donnés à apical
#param collider: ce qui a fait une collision
#param damage: le nombre de dégats
func hit(collider, damage):
	if (collider.is_in_group("Balle") || collider.is_in_group("Joueur")) && !self.mort:
		vie -= damage
		son_hit = true
		get_node("SonHit").play()
		if vie <= 0:
			self.mort = true

#Fonction qui gère l'intro du boss apical
#param delta: pour gérer la vitesse des animation
func intro_apical(delta):
	#On attend de détecter le joueur avant de déclencher l'intro
	if !detection_joueur:
		tourner_vers_joueur()
		fonction_detection_joueur()
	#Quand on a détecté le joueur, on fait le déplacement vers la position d'intro
	elif !position_intro_ok:
		son_ambiance = true
		#Je prends la hauteur par rapport au joueur
		if !memoire_hauteur:
			if get_node("../Joueur"):
				if get_node("../Joueur").is_on_floor:
					hauteur = get_node("../Joueur").position.y - 50
					memoire_hauteur = true
					vitesse_ennemi /=8
		else:
			if position.x > 0 + vitesse_ennemi:
				mouvement_cote = -vitesse_ennemi
			elif position.x < 0:
				mouvement_cote = vitesse_ennemi
			else:
				mouvement_cote = 0
			
			if position.y < hauteur:
				mouvement_haut = vitesse_ennemi
			elif position.y > hauteur + vitesse_ennemi:
				mouvement_haut = -vitesse_ennemi
			else:
				mouvement_haut = 0
			
			if mouvement_cote == 0 && mouvement_haut == 0:
				position_intro_ok = true
				
			bouger_apical()
	#On lance l'intro quand on est arrivés à la bonne position
	elif position_intro_ok:
		#On rend visible progressivement la bulle de discussion
		#Lorsqu'elle est visible, on lance un timer pour laisser le temps de la lire
		if !bulle_vue:
			get_node("Bulle").visible = true
			if get_node("Bulle").modulate.a < 1:
				get_node("Bulle").modulate.a += delta
			elif !timer_bulle:
				get_node("TimerBulle").start()
				timer_bulle = true
		#Quand le tier est fini, on rend la bulle invisible progressivement
		else:
			if get_node("Bulle").modulate.a > 0:
				get_node("Bulle").modulate.a -= delta
			#Quand la bulle n'est plus visible, on active els différentes collisions et on start les phases du boss
			else:
				get_node("Bulle").visible = false
				get_node("Vie").visible = true
				get_node("CollisionShape2D").disabled = false
				position_intro_ok = false
				bulle_vue = false
				timer_bulle = false
				memoire_hauteur = false
				vitesse_ennemi = mem_vitesse
				phase = 2

#Fonction qui gère la phase de tir d'apical
func tirer_apical():
	var balle = balleApical.instance()
	if !memoire_hauteur:
		if get_node("../Joueur"):
			if get_node("../Joueur").is_on_floor:
				hauteur = get_node("../Joueur").position.y - 100
				memoire_hauteur = true
	
	#On se déplace à la bonne position
	if !position_tir_ok && memoire_hauteur:
		if position.x > 0 + vitesse_ennemi:
			mouvement_cote = -vitesse_ennemi
		elif position.x < 0:
			mouvement_cote = vitesse_ennemi
		else:
			mouvement_cote = 0
			
		if position.y < hauteur:
			mouvement_haut = vitesse_ennemi
		elif position.y > hauteur + vitesse_ennemi:
			mouvement_haut = -vitesse_ennemi
		else:
			mouvement_haut = 0
			
		if mouvement_cote == 0 && mouvement_haut == 0:
			position_tir_ok = true
		bouger_apical()
	#Quand on est à la bonne position, on tire à intervalles réguliers jusqu'au nombre de balles défini
	if tir && position_tir_ok && nb_balles < balles_max:
		balle.directionX = balle.vitesse
		balle.position = position + Vector2(0,30)
		if get_node("../Joueur"):
			balle.look_at(get_node("../Joueur").position)
		son_tir = true
		get_node("SonTir").play()
		get_parent().add_child(balle)
		tir = false
		cooldownDeTir.start(temps_tir)
		nb_balles += 1
	#Quand toutes es bales sonnt tirées, on passe à la phase suivante
	elif nb_balles >= balles_max:
		phase = 2
		memoire_hauteur = false
		position_tir_ok = false
		nb_balles = 0

#Fonction pour faire bouger apical et gérer les collisions
func bouger_apical():
	collision_mouvement = move_and_collide(Vector2(mouvement_cote,mouvement_haut))
	if collision_mouvement:
		if collision_mouvement.collider.has_method("hit"):
			collision_mouvement.collider.hit(self,damage)

#Fonction pour gérer la phase de dash d'apical
#param delta: pour gérer la vitesse des animations
func dash_apical(delta):
	if !memoire_hauteur:
		if get_node("../Joueur"):
			if get_node("../Joueur").is_on_floor:
				hauteur = get_node("../Joueur").position.y
				memoire_hauteur = true
				print(hauteur)
				print(get_node("../Joueur").position.y)
	#O se déplace à la bonne position
	if !dash && memoire_hauteur:
		if sens:
			if position.x > depart_niveau + vitesse_ennemi:
				mouvement_cote = -vitesse_ennemi
			elif position.x < depart_niveau - vitesse_ennemi:
				mouvement_cote = vitesse_ennemi
			else:
				mouvement_cote = 0
		else:
			if position.x > fin_niveau + vitesse_ennemi:
				mouvement_cote = -vitesse_ennemi
			elif position.x < fin_niveau - vitesse_ennemi:
				mouvement_cote = vitesse_ennemi
			else:
				mouvement_cote = 0
				
		if position.y < hauteur:
			mouvement_haut = vitesse_ennemi
		elif position.y > hauteur + vitesse_ennemi:
			mouvement_haut = -vitesse_ennemi
		else:
			mouvement_haut = 0
			
		if mouvement_cote == 0 && mouvement_haut == 0:
			dash = true
		bouger_apical()
	#Quand on est à la bonne position, on commence le dash
	else:
		mouvement_haut = 0
		#On fait tourner le sprite pour avertir le joueur qu'apical va dasher
		if sens:
			animation.rotation += vitesse_rotation
		else:
			animation.rotation -= vitesse_rotation
		if !dash_ok:
			#On active le dash quand apical tourne assez vite
			vitesse_rotation += delta/2
			if vitesse_rotation > 0.5:
				dash_ok = true
		else:
			#On dash dans le sens donné
			if sens:
				mouvement_cote = vitesse_dash
				if position.x < fin_niveau:
					bouger_apical()
					if collision_mouvement:
						if collision_mouvement.get_collider().name == "Joueur":
							set_collision_mask_bit(0, false)
				#Quand les 2 dash sont faits, on passe à la phase suivante
				else:
					set_collision_mask_bit(0, true)
					vitesse_ennemi = mem_vitesse
					dash_ok = false
					dash = false
					phase = 1
					sens = false
					vitesse_rotation = 0
					memoire_hauteur = false
					self.animation.rotation = 0
			else:
				mouvement_cote = -vitesse_dash
				if position.x > depart_niveau:
					bouger_apical()
					if collision_mouvement:
						if collision_mouvement.get_collider().name == "Joueur":
							set_collision_mask_bit(0, false)
				#Quand un dash est fait, on fait un autre dash de l'Autre sens
				else:
					set_collision_mask_bit(0, true)
					sens = true
					vitesse_ennemi = mem_vitesse
					dash_ok = false
					dash = false
					vitesse_rotation = 0
					memoire_hauteur = false
	
#Fonction pour gérer la phase marteau d'apical
func marteau_apical():
	if !memoire_hauteur:
		if get_node("../Joueur"):
			if get_node("../Joueur").is_on_floor:
				hauteur = get_node("../Joueur").position.y - 75
				memoire_hauteur = true
	#On se déplace à la position du prochain bloc
	if !marteau && memoire_hauteur:
		var position_prochain_bloc
		position_prochain_bloc = 64*bloc + depart_niveau + 16
		if position.y < hauteur:
			mouvement_haut = vitesse_ennemi
		elif position.y > hauteur + vitesse_ennemi:
			mouvement_haut = -vitesse_ennemi
		else:
			mouvement_haut = 0
			
		if position.x < position_prochain_bloc - vitesse_ennemi:
			mouvement_cote = vitesse_ennemi
		elif position.x > position_prochain_bloc:
			mouvement_cote = -vitesse_ennemi
		else:
			mouvement_cote = 0
		if mouvement_cote == 0 && mouvement_haut == 0:
			marteau = true
		bouger_apical()
	#On fait le mouvement du marteau
	else:
		if !marteau_fait:
			vitesse_ennemi = vitesse_marteau
			mouvement_cote = 0
			mouvement_haut = vitesse_ennemi
			if position.y < hauteur + profondeur_marteau*32 + 16:
				bouger_apical()
				if collision_mouvement:
					if collision_mouvement.get_collider().name == "Joueur":
						set_collision_mask_bit(0, false)
			else:
				marteau_fait = true
		elif bloc <= 11: 
			vitesse_ennemi = mem_vitesse
			mouvement_haut = -vitesse_ennemi
			if position.y > hauteur:
				bouger_apical()
			else:
				set_collision_mask_bit(0, true)
				marteau = false
				marteau_fait = false
				bloc+=1
	#Si on atteint 11 fois le marteau, soit la longueur de la map, on passe à la phase suivante
	if bloc >11:
		sens = true
		bloc = 0
		phase = 3
		memoire_hauteur = false
		hauteur = 0
		sens = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.damage = 5
	mem_vitesse = vitesse_ennemi
	get_node("Bulle").modulate.a = 0
	get_node("Bulle").visible = false
	get_node("Vie").visible = false
	get_node("CollisionShape2D").disabled = true

#Fonction principale
func _physics_process(delta):
	if !self.mort:
		#On active un mode plus rapide lorsque qu'apical est en dessous de 15% de vie
		print((vie*100) / vie_max)
		if (vie*100) / vie_max <= 15 && !mem_vie_basse:
			vitesse_ennemi *=2
			vitesse_marteau *= 2
			vitesse_dash *= 2
			modulate.r = 2
			get_node("Vie").modulate.r = 10
			temps_tir /=2
			mem_vie_basse = true
			
		if phase == 0:
			intro_apical(delta)
		if phase == 1:
			tirer_apical()
		if phase == 2:
			marteau_apical()
		elif phase == 3:
			dash_apical(delta)
		
		#On gère la musique de fond
		if son_ambiance:
			get_parent().get_node("Ambiance").stream_paused = false
		else:
			get_parent().get_node("Ambiance").stream_paused = true
	else:
		#Animation pour la mort d'apical
		if !mem_mort:
			get_node("Vie").visible = false
			self.modulate.a = 5
			mem_mort = true
		get_parent().get_node("Ambiance").volume_db -= delta*50


#On dit que la bulle est vue lorsque le timer est terminé
func _on_TimerBulle_timeout():
	bulle_vue = true
