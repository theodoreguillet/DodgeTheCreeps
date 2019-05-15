extends Area2D

signal player_hit

# Declare member variables here. Examples:
export (int) var SPEED = 400
export (bool) var CLAMP = false

var screenSize

var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	$Particles2D.emitting = false
	
	screenSize = get_viewport_rect().size
	
	velocity.x = 0
	velocity.y = 0
	
	if Input.is_action_pressed("ui_right") :
		velocity.x += 1
	if Input.is_action_pressed("ui_left") :
		velocity.x -= 1
	if Input.is_action_pressed("ui_down") :
		velocity.y += 1
	if Input.is_action_pressed("ui_up") :
		velocity.y -= 1
		
	connect("body_entered", self, "onBodyEntered")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	screenSize = get_viewport_rect().size
		
	velocity.x = 0
	velocity.y = 0
	
	if Input.is_action_pressed("ui_right") :
		velocity.x += 1
	if Input.is_action_pressed("ui_left") :
		velocity.x -= 1
	if Input.is_action_pressed("ui_down") :
		velocity.y += 1
	if Input.is_action_pressed("ui_up") :
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
		$Particles2D.emitting = true
	else :
		$Particles2D.emitting = false

func onBodyEntered(body: PhysicsBody2D) :
	emit_signal("player_hit");

