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
				Global.memoire_scene = "res://Scenes/" + get_parent().name + ".tscn"
				print(Global.memoire_scene)
				Global.goto_scene("res://Scenes/GameOver.tscn")
			else:
				queue_free()
	else:
		get_node("Mort").stream_paused = false
	
	
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


func _on_coolDownDeTir_timeout():
	tir = true
