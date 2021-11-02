extends "res://Scripts/personnage.GD"

func _process(delta):
	if (Input.is_action_pressed("DROIT")):
		move_and_collide(Vector2(self.vitesse,0))
	if (Input.is_action_pressed("GAUCHE")):
		move_and_collide(Vector2(-self.vitesse,0))
