extends KinematicBody2D

var velocityY = 0

export(float) var cooldown_de_tir
export(float) var GRAVITY = 0.98

const balleScene = preload("res://Scenes/Balle.tscn")
var is_on_floor = false

var cooldownDeTir
var ballePositionDroit
var ballePositionHaut
var ballePositionBas
var animation
var tir = true

func _ready():
	animation = get_node("AnimatedSprite")
	cooldownDeTir = get_node("cooldown de tir")
	ballePositionDroit = get_node("position de tir droit").position
	ballePositionHaut = get_node("position de tir haut").position
	ballePositionBas = get_node("position de tir bas").position

func _physics_process(delta):
	velocityY += GRAVITY
	var t = move_and_collide(Vector2(0,velocityY))
	if t != null:
		is_on_floor = true
		velocityY = 0
	else:
		is_on_floor = false


func tirer(dir_balle):
		
	if tir and cooldownDeTir.is_stopped():
		var balle = balleScene.instance()
		
		if dir_balle == "haut":
			balle.directionY = -balle.vitesse
			balle.position = position + ballePositionHaut
			get_parent().add_child(balle)
			cooldownDeTir.start(cooldown_de_tir)
			
		elif dir_balle == "bas" && !is_on_floor:
			balle.directionY = +balle.vitesse
			balle.position = position + ballePositionBas
			get_parent().add_child(balle)
			cooldownDeTir.start(cooldown_de_tir)
			
		elif dir_balle == "droit" && animation.flip_h:
			balle.directionX = -balle.vitesse
			balle.position = position - ballePositionDroit
			get_parent().add_child(balle)
			cooldownDeTir.start(cooldown_de_tir)
			
		elif dir_balle == "droit" && !animation.flip_h:
			balle.directionX = +balle.vitesse
			balle.position = position + ballePositionDroit
			get_parent().add_child(balle)
			cooldownDeTir.start(cooldown_de_tir)
