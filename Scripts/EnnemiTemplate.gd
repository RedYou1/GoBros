extends Node2D

export(float) var vitesse = 10
export(float) var GRAVITY = 0.98
export(float) var cooldown_de_tir = .2

const balleScene = preload("res://Scenes/Balle.tscn")

var velocityY = 0
var is_on_floor = false

var body
var collision
var sens = false


func _ready():
	body = get_node("KinematicBody2D")
	collision = get_node("KinematicBody2D/CollisionShape2D")

func _physics_process(delta):
	velocityY += GRAVITY
	var t = body.move_and_collide(Vector2(0,velocityY))
	if t != null:
		is_on_floor = true
		velocityY = 0
	else:
		is_on_floor = false

