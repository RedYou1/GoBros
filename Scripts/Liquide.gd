extends Area2D


func _on_Liquide_body_entered(body):
	body.is_in_liquide = true


func _on_Liquide_body_exited(body):
	body.is_in_liquide = false
