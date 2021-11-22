extends Control
	
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if get_node("Son").get_playback_position() >= get_node("Son").stream.get_length() - 0.05:
		get_node("Son").stream_paused = true


func _on_Retour_pressed():
	Global.goto_scene("res://Scenes/Menu.tscn")


func _on_Quitter_pressed():
	get_tree().quit()


func _on_Restart_pressed():
	Global.goto_scene(Global.memoire_scene)
