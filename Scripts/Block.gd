extends KinematicBody2D


export(float) var GRAVITY = 0.98
export(int) var vie = 5
export(int) var distance_despawn = 10000

var sleep
var explosion
var velocityY = 0

func _ready():
	explosion = get_node("explosion")

func _physics_process(delta):
	if get_node("DansEcran").is_on_screen():
		if not sleep:
			if GRAVITY != 0:
				velocityY += GRAVITY
				var t = move_and_collide(Vector2(0,velocityY))
				if t != null:
					velocityY = 0
					sleep = true
				else:
					unSleep()
	
		if position.y > distance_despawn:
			queue_free()

func hit(from,damage):
	vie -= damage
	if vie <= 0:
		get_node("Sprite").visible = false
		get_node("CollisionShape2D").disabled = true
		explosion.visible = true
		explosion.playing = true
		var raycast = get_node("block_above")
		var col = raycast.get_collider()
		if col != null and col.is_in_group("Block"):
			col.unSleep()


func _on_explosion_animation_finished():
	queue_free()

func unSleep():
	sleep = false
	var raycast = get_node("block_above")
	var col = raycast.get_collider()
	if col != null and col.is_in_group("Block"):
		col.unSleep()
