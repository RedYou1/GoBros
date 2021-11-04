extends "res://Scripts/EnemyDeBase.gd"


# Declare member variables here. Examples:

func robot_sauter():
	self.collision.position.y = -8
	self.animation.position.y = -8
	self.animation.animation = "sauter"
	self.sauter()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
