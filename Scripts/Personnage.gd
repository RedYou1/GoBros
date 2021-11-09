extends KinematicBody2D

var velocityY = 0

export(float) var cooldown_de_tir = .2
export(float) var GRAVITY = 0.98

const balleScene = preload("res://Scenes/Balle.tscn")
var is_on_floor = false

var cooldownDeTir
var ballePosition
var animation
var tir = true

func _ready():
	animation = get_node("AnimatedSprite")
	cooldownDeTir = get_node("cooldown de tir")
	ballePosition = get_node("position de tir").position

func _physics_process(delta):
	velocityY += GRAVITY
	var t = move_and_collide(Vector2(0,velocityY))
	if t != null:
		is_on_floor = true
		velocityY = 0
	else:
		is_on_floor = false


func tirer():
	if !tir and cooldownDeTir.is_stopped():
		var balle = balleScene.instance()
		
		if animation.flip_h:
			balle.direction *= -1
			balle.position = position - ballePosition
		else:
			balle.position = position + ballePosition
		get_parent().add_child(balle)
		cooldownDeTir.start(cooldown_de_tir)
