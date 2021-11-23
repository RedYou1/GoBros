extends AnimatedSprite


# Declare member variables here. Examples:
var play = false
var rng = RandomNumberGenerator.new()
var delay

# Called when the node enters the scene tree for the first time.
func _ready():
	#On défnit un délai en random pour décaler les feux d'Artifices les uns des autres
	visible = false
	rng.randomize()
	delay = rng.randf_range(0, 3)
	get_node("Timer").start(delay)

func _physics_process(delta):
	if play:
		get_node("Son").stream_paused = false
		visible = true
		playing = true


func _on_Timer_timeout():
	play = true
