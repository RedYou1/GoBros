extends KinematicBody2D

export(float) var vitesse = 10
export(float) var direction = 10
export(float) var directionX = 0
export(float) var directionY = 0
export(int) var damage = 1
var movement
var mort = false

func _ready():
	movement = Vector2(directionX,directionY).rotated(rotation)# * delta
	if rotation == 0:
		get_node("Sprite").rotation = movement.angle()

func _physics_process(delta):
	var col = move_and_collide(movement)
	
	if col != null:
		if col.collider.has_method("hit"):
			col.collider.hit(self,damage)
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
