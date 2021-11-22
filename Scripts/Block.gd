extends KinematicBody2D


export(float) var GRAVITY = 0.98
export(int) var vie = 5
export(int) var distance_despawn = 10000
export(bool) var sleep = false

var explosion
var raycast
var velocityY = 0

func _ready():
	explosion = get_node("explosion")
	raycast = get_node("block_above")

func _physics_process(delta):
	if not sleep:
		if GRAVITY != 0 && get_node("DansEcran").is_on_screen():
			velocityY += GRAVITY
			var t = move_and_collide(Vector2(0,velocityY))
			if t != null:
				velocityY = 0
				sleep = true
				raycast.enabled = false
			else:
				unSleep()
			if position.y > distance_despawn:
				queue_free()
		else:
			raycast.enabled = false
			sleep = true

func hit(from,damage):
	vie -= damage
	if vie <= 0:
		get_node("Sprite").visible = false
		get_node("CollisionShape2D").disabled = true
		get_node("SonExplosion").play()
		explosion.visible = true
		explosion.playing = true
		raycast.enabled = true
		var col = raycast.get_collider()
		if col != null and col.is_in_group("Block"):
			col.unSleep()
		raycast.enabled = false


func _on_explosion_animation_finished():
	queue_free()

func unSleep():
	sleep = false
	raycast.enabled = true
	var col = raycast.get_collider()
	if col != null and col.is_in_group("Block") and col.sleep:
		col.unSleep()
