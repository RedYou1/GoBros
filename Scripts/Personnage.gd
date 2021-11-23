extends KinematicBody2D

var velocityY = 0

export(float) var GRAVITY = 0.98

var vie
export(int) var vie_max = 3
export(int) var distance_despawn = 10000
export(float) var temps_tir = 1.0
var mort = false

var is_on_floor = false

var collision
var ballePositionDroit
var ballePositionHaut
var ballePositionBas
var animation
var cooldownDeTir


var is_in_liquide = 0
var son_tir = false
var son_hit = false
var son_mort = false
var tir = false

#Fonction pour gérer la mort des personnages
func mourir(delta):
	#On active l'animation de mort et le son de mort
	if self.animation.animation != "mourir":
		self.animation.animation = "mourir"
		self.animation.frame = 0
		self.animation.playing = true
		son_mort = true
	if animation.frame == animation.frames.get_frame_count("mourir")-1:
		self.animation.playing = false
		modulate.a -= delta
		if modulate.a <= 0:
			if self.name == "Joueur":
				#On met en mémoire la scène courante pour pouvoir recommencer le niveau dans le menu de game over
				Global.memoire_scene = "res://Scenes/" + get_parent().name + ".tscn"
				print(Global.memoire_scene)
				Global.goto_scene("res://Scenes/GameOver.tscn")
			else:
				queue_free()
	
#Fonction init	
func _ready():
	collision = get_node("CollisionShape2D")
	animation = get_node("AnimatedSprite")
	ballePositionDroit = get_node("position de tir droit").position
	ballePositionHaut = get_node("position de tir haut").position
	ballePositionBas = get_node("position de tir bas").position
	cooldownDeTir = get_node("coolDownDeTir")
	cooldownDeTir.wait_time = temps_tir
	cooldownDeTir.start()
	vie = vie_max

#Fonction principale
func _physics_process(delta):
	velocityY += GRAVITY
	
	#On modifie la gravité si le personnage est dans un liquide
	if is_in_liquide > 0:
		if velocityY > 3:
			velocityY = 3
		elif velocityY < -12:
			velocityY = -12
	
	var t = move_and_collide(Vector2(0,velocityY))
	if t != null:
		is_on_floor = true
		velocityY = 0
	else:
		is_on_floor = false
	
	#On g;ere la mort
	if mort:
		mourir(delta)
	
	#On meurt si on dépasse la distance de despawn
	if position.y > distance_despawn:
		mort = true
	
	#On gère les différents sont du personnage
	if son_tir:
		get_node("SonTir").stream_paused = false
		if get_node("SonTir").get_playback_position() >= temps_tir || get_node("SonTir").get_playback_position() >= get_node("SonTir").stream.get_length() - 0.05:
			son_tir = false
	else:
		get_node("SonTir").stream_paused = true
		get_node("SonTir").play()
	
	if son_hit:
		get_node("SonHit").stream_paused = false
		if get_node("SonHit").get_playback_position() >= get_node("SonHit").stream.get_length() - 0.07:
			son_hit = false
	else:
		get_node("SonHit").stream_paused = true
		get_node("SonHit").play()
	
	if son_mort:
		get_node("Mort").stream_paused = false
		if get_node("Mort").get_playback_position() >= get_node("Mort").stream.get_length() - 0.05:
			son_mort = false
	else:
		get_node("Mort").stream_paused = true
		get_node("Mort").play()

#Timer pour le tir
func _on_coolDownDeTir_timeout():
	tir = true
