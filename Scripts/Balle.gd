extends KinematicBody2D

export(float) var vitesse = 10
export(float) var direction = 10
export(float) var directionX = 0
export(float) var directionY = 0
export(int) var damage = 1
var movement

func _ready():
	movement = Vector2(directionX,directionY)# * delta

func _physics_process(delta):
	
	var col = move_and_collide(movement)
	
	if col != null:
		if col.collider.has_method("hit"):
			col.collider.hit(self,damage)
		queue_free()
