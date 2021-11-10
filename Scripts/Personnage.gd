extends KinematicBody2D

var velocityY = 0

export(float) var cooldown_de_tir = 0.1
export(float) var GRAVITY = 0.98

var vie
export(int) var vie_max = 3
export(int) var distance_despawn = 10000
var mort = false
const balleScene = preload("res://Scenes/Balle.tscn")

var is_on_floor = false

var collision
var cooldownDeTir = 0.2
var ballePositionDroit
var ballePositionHaut
var ballePositionBas
var animation
var tir = false

func mourir(delta):
	if self.animation.animation != "mourir":
		self.animation.animation = "mourir"
		self.animation.frame = 0
		self.animation.playing = true
	if animation.frame == animation.frames.get_frame_count("mourir")-1:
		self.animation.playing = false
		modulate.a -= delta
		if modulate.a <= 0:
			if self.name == "Joueur":
				Global.goto_scene("res://Scenes/GameOver.tscn")
			else:
				queue_free()
	
	
func _ready():
	collision = get_node("CollisionShape2D")
	animation = get_node("AnimatedSprite")
	cooldownDeTir = get_node("cooldown de tir")
	ballePositionDroit = get_node("position de tir droit").position
	ballePositionHaut = get_node("position de tir haut").position
	ballePositionBas = get_node("position de tir bas").position
	vie = vie_max

func _physics_process(delta):
	velocityY += GRAVITY
	var t = move_and_collide(Vector2(0,velocityY))
	if t != null:
		is_on_floor = true
		velocityY = 0
	else:
		is_on_floor = false
	
	if mort:
		mourir(delta)
	
	if position.y > distance_despawn:
		mort = true
