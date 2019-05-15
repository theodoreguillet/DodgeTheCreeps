extends Area2D

signal player_hit

# Declare member variables here. Examples:
export (int) var SPEED = 400
export (bool) var CLAMP = false

export (bool) var FORCE_CPU_PARTICLES = false

var screenSize

var velocity = Vector2()

var particles: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	print("Video driver: " + OS.get_video_driver_name(OS.get_current_video_driver()))
	if OS.get_name() == "HTML5" or FORCE_CPU_PARTICLES:
		print("Working on web");
		print("Using CPUParticles2D")
		particles = $CPUParticles2D;
		$Particles2D.emitting = false
		$Particles2D.hide()
	else :
		print("Using Particles2D")
		particles = $Particles2D;
		$CPUParticles2D.emitting = false
		$CPUParticles2D.hide()

	screenSize = get_viewport_rect().size
		
	connect("body_entered", self, "onBodyEntered")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	screenSize = get_viewport_rect().size
		
	velocity.x = 0
	velocity.y = 0
	
	if Input.is_key_pressed(KEY_RIGHT) : # right
		velocity.x += 1
	if Input.is_key_pressed(KEY_LEFT) : # left
		velocity.x -= 1
	if Input.is_key_pressed(KEY_DOWN) : # down
		velocity.y += 1
	if Input.is_key_pressed(KEY_UP) : # up
		velocity.y -= 1
		
	if velocity.length() > 0 :
		velocity = velocity.normalized() * SPEED
		$AnimatedSprite.play();
		position += velocity * delta
	else :
		$AnimatedSprite.stop()
	
	if CLAMP :
		position = Vector2(clamp(position.x, 0, screenSize.x), clamp(position.y, 0, screenSize.y))
	else :
		if position.x > screenSize.x :
			position.x = 0
		elif position.x < 0 :
			position.x = screenSize.x
			
		if position.y > screenSize.y :
			position.y = 0
		elif position.y < 0 :
			position.y = screenSize.y
	
	if $AnimatedSprite.is_playing() :
		$AnimatedSprite.animation = "droite" if velocity.x != 0 else "haut"
		$AnimatedSprite.flip_h = velocity.x < 0
		$AnimatedSprite.flip_v = velocity.y > 0
		particles.emitting = true
	else :
		particles.emitting = false

func onBodyEntered(body: PhysicsBody2D) :
	emit_signal("player_hit");

