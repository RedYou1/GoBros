extends RigidBody2D


export(int) var vie = 5


func hit(from,damage):
	vie -= damage
	apply_impulse(from.position-position,Vector2(from.direction,0))
	if vie <= 0:
		queue_free()
