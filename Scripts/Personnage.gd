extends KinematicBody2D

export(float) var vitesse = 10
export(float) var GRAVITY = 0.98

var velocityY = 0
var is_on_floor = false

func _physics_process(delta):
	velocityY += GRAVITY
	var t = move_and_collide(Vector2(0,velocityY))
	if t != null:
		is_on_floor = true
		velocityY = 0
	else:
		is_on_floor = false
