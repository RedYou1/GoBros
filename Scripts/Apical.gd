extends "res://Scripts/EnemyDeBase.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func hit(collider, damage):
	self.standard_hit(collider, damage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
