extends KinematicBody2D

export(float) var vitesse = 10
var direction = 10
var directionX = 0
var directionY = 0
export(int) var damage = 1

func _physics_process(delta):
	var col = move_and_collide(Vector2(directionX,directionY))
	
	if col != null:
		if col.collider.has_method("hit"):
			col.collider.hit(self,damage)
		queue_free()
