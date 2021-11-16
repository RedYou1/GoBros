extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("ColorRect").visible = true;


func _process(delta):
	if get_node("ColorRect").modulate.a > 0:
		get_node("ColorRect").modulate.a -= delta
	else:
		get_node("ColorRect").modulate.a = 0
		get_node("ColorRect").visible = false;
