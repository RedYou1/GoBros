extends Node2D

export(float) var vitesse = 10
export(float) var GRAVITY = 0.98
export(float) var cooldown_de_tir = .2

const balleScene = preload("res://Scenes/Balle.tscn")

var velocityY = 0
var is_on_floor = false

var body
var cooldownDeTir
var ballePosition
var animation
var tir = false

func _ready():
	body = get_node("KinematicBody2D")
	animation = get_node("AnimatedSprite")

func _physics_process(delta):
	velocityY += GRAVITY
	var t = body.move_and_collide(Vector2(0,velocityY))
	if t != null:
		is_on_floor = true
		velocityY = 0
	else:
		is_on_floor = false


func tirer():
	if tir and cooldownDeTir.is_stopped():
		var balle = balleScene.instance()
		
		if animation.flip_h:
			balle.direction *= -1
			balle.position = position - ballePosition
		else:
			balle.position = position + ballePosition
		get_parent().add_child(balle)
		cooldownDeTir.start(cooldown_de_tir)
