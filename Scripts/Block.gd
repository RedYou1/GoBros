extends RigidBody2D


export(int) var vie = 5

var explosion

func _ready():
	explosion = get_node("explosion")

func hit(from,damage):
	vie -= damage
	apply_impulse(from.position-position,Vector2(from.direction,0))
	if vie <= 0:
		get_node("Sprite").visible = false
		get_node("CollisionShape2D").disabled = true
		explosion.visible = true
		explosion.playing = true


func _on_explosion_animation_finished():
	queue_free()
