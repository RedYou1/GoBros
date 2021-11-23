extends Node


# Declare member variables here. Examples:
var current_scene


# Called when the node enters the scene tree for the first time.
func _ready():
	#On met la scène présente dans une variable pour pouvoir recommencer le niveau
	current_scene = "res://Scenes/" + get_parent().get_parent().name + ".tscn"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#On active la pause lorsque la touche pause est pesée
	if Input.is_action_just_pressed("PAUSE") && !self.visible:
		self.visible = true
		get_tree().paused = true
	elif Input.is_action_just_pressed("PAUSE") && self.visible:
		self.visible = false
		get_tree().paused = false

#Retour au jeu
func _on_Retour_button_down():
	get_tree().paused = false
	self.visible = false
	
#Retour au début du niveau
func _on_RetourDebut_button_down():
	get_tree().paused = false
	Global.goto_scene(current_scene)

#Retour au menu principal
func _on_MenuPrincipal_button_down():
	get_tree().paused = false
	Global.goto_scene("res://Scenes/Menu.tscn")
