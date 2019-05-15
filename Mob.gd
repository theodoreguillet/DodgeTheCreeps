extends RigidBody2D

const ANIMATIONS = [
	"marche",
	"nage",
	"vol"
]

# Declare member variables here.


# Called when the node enters the scene tree for the first time.
func _ready():
	$visibility.connect("screen_exited", self, "onScreenExited")
	
	var anim = ANIMATIONS[randi() % ANIMATIONS.size()];
	# print("anim: ", anim)
	$AnimatedSprite.animation = anim
	$AnimatedSprite.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
#	pass
	
func onScreenExited() :
	# print("onScreenExited")
	queue_free()


