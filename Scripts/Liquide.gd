extends Area2D


func _on_Liquide_body_entered(body):
	if body.is_in_group("Personnage"):
		body.is_in_liquide += 1


func _on_Liquide_body_exited(body):
	if body.is_in_group("Personnage"):
		body.is_in_liquide -= 1
