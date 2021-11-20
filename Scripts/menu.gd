extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("CenterContainer/VBoxContainer/Button").grab_focus() #permet de changer de bouton via flèche du clavier


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#bouton jouer
func _on_Button_pressed():
	Global.goto_scene("res://Scenes/tutoControl.tscn")

#bouton options
func _on_Button2_pressed():
	get_node("Crédits").visible = true

#boutons quitter
func _on_Button3_pressed():
	get_tree().quit()


func _on_Button4_pressed():
	get_node("Controles").visible = true
