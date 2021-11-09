extends KinematicBody2D

export(float) var direction = 10
export(int) var damage = 1

func _physics_process(delta):
	var col = move_and_collide(Vector2(direction,0))
	
	if col != null:
		if col.collider.has_method("hit"):
			col.collider.hit(self,damage)
		queue_free()
