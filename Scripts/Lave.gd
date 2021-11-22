extends "res://Scripts/Liquide.gd"

export(float) var damage = .1

var bodies = []

func _process(delta):
	for body in get_overlapping_bodies():
		if body.has_method("hit"):
			body.hit(self,damage)
