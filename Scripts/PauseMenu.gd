extends Node


# Declare member variables here. Examples:
var current_scene


# Called when the node enters the scene tree for the first time.
func _ready():
	current_scene = "res://Scenes/" + get_parent().get_parent().name + ".tscn"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("PAUSE") && !self.visible:
		self.visible = true
		get_tree().paused = true
	elif Input.is_action_just_pressed("PAUSE") && self.visible:
		self.visible = false
		get_tree().paused = false


func _on_Retour_button_down():
	get_tree().paused = false
	self.visible = false
	

func _on_RetourDebut_button_down():
	get_tree().paused = false
	Global.goto_scene(current_scene)


func _on_MenuPrincipal_button_down():
	get_tree().paused = false
	Global.goto_scene("res://Scenes/Menu.tscn")
