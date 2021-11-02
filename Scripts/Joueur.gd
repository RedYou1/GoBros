extends "res://Scripts/Personnage.GD"

func _process(delta):
	if Input.is_action_pressed("DROIT"):
		move_and_collide(Vector2(self.vitesse,0))
	if Input.is_action_pressed("GAUCHE"):
		move_and_collide(Vector2(-self.vitesse,0))
	if Input.is_action_just_pressed("HAUT") and self.is_on_floor:
		self.velocityY = -15
