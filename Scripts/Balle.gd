extends KinematicBody2D

export(float) var vitesse = 10
export(float) var direction = 10
export(float) var directionX = 0
export(float) var directionY = 0
export(int) var damage = 1

var rayCastBlock

func _ready():
	rayCastBlock = get_node("RayCastBlock")

func _physics_process(delta):
	
	var movement = Vector2(directionX,directionY)# * delta
	
	rayCastBlock.cast_to = movement+Vector2(10,0).rotated(movement.angle())
	
	var col = rayCastBlock.get_collider()
	
	if col != null and col.is_in_group("Block"):
		col.hit(self,damage)
		print("block")
		queue_free()
		return
	
	col = move_and_collide(movement)
	
	if col != null:
		if col.collider.has_method("hit"):
			col.collider.hit(self,damage)
		queue_free()
