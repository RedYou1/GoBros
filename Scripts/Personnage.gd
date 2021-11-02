extends KinematicBody2D

export(float) var vitesse = 10
export(float) var GRAVITY = 0.098

var velocityY = 0

func _physics_process(delta):
	velocityY += GRAVITY
	move_and_collide(Vector2(0,velocityY))
