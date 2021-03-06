extends Node2D

# Declare member variables here. Examples:
export (String) var message
export (int) var distance_activation = 50
var distance_joueur = 0
var lu_par_joueur = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#On met le message de la bulle au message écrit dans les options
	get_node("Bulle/Node2D/Message").text = message
	get_node("Bulle").modulate.a = 0

#Fonction principale
func _physics_process(delta):
	#On affiche la bulle quand le joueur est assez proche
	if get_node("../Joueur"):
		distance_joueur = get_node("../Joueur").position.x - position.x;
		if distance_joueur < 0:
			distance_joueur *= -1
		if distance_joueur < distance_activation:
			if get_node("Bulle").modulate.a < 1:
				get_node("Bulle").modulate.a += delta
			else:
				get_node("Bulle").modulate.a = 1
				lu_par_joueur = true
		#Si la bulle est déjà apparue et que le mob_tutoriel tombe en dehors de l'écran, il disparait
		else:
			if get_node("Bulle").modulate.a > 0:
				get_node("Bulle").modulate.a -= delta
			else:
				get_node("Bulle").modulate.a = 0
				if lu_par_joueur && !get_node("DansEcran").is_on_screen():
					queue_free()
