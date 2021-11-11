extends KinematicBody2D


export(float) var GRAVITY = 0.98
export(int) var vie = 5
export(int) var distance_despawn = 10000

var explosion
var velocityY = 0

func _ready():
	explosion = get_node("explosion")

func _physics_process(delta):
	if GRAVITY != 0:
		velocityY += GRAVITY
		var t = move_and_collide(Vector2(0,velocityY))
		if t != null:
			velocityY = 0
	
	if position.y > distance_despawn:
		queue_free()

func hit(from,damage):
	vie -= damage
	if vie <= 0:
		get_node("Sprite").visible = false
		get_node("CollisionShape2D").disabled = true
		explosion.visible = true
		explosion.playing = true


func _on_explosion_animation_finished():
	queue_free()
