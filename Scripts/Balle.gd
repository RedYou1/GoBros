extends Node2D

export(float) var direction = 200
export(int) var damage = 1

var ray

func _ready():
	ray = get_node("RayCast2D")

func _physics_process(delta):
	ray.cast_to.x = direction * delta
	
	var col = ray.get_collider()
	
	if col == null:
		position.x += direction * delta
	else:
		if col.has_method("hit"):
			col.hit(self,damage)
		queue_free()
