extends RigidBody2D


export(int) var vie = 5


func hit(from,damage):
	vie -= damage
	if vie <= 0:
		queue_free()
