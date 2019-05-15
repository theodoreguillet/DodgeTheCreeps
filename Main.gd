extends Node2D

export (PackedScene) var Mob

# Declare member variables here.
var score: int

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	$MobTimer.connect("timeout", self, "onMobTimerTimeout")
	$ScoreTimer.connect("timeout", self, "onScoreTimerTimeout")
	
	$Player.connect("player_hit", self, "onGameOver")
	$Menu.connect("game_started", self, "onGameStarted")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_score(score: int) :
	self.score = score
	$Menu.UpdateScore(score)

func cleanMobs() :
	for child in get_children() :
		if child.name == "Mob" or "@Mob@" in child.name :
			child.queue_free()

func onMobTimerTimeout() :
	$MobTimer.start()
	
	var mob = Mob.instance() as RigidBody2D
	self.add_child(mob)
	
	$Path2D/PathFollow2D.offset = randi()
	
	mob.position = $Path2D/PathFollow2D.position
	
	mob.rotation_degrees = $Path2D/PathFollow2D.rotation_degrees + randi() % 91
	
	mob.linear_velocity = Vector2(cos(mob.rotation) * 200, sin(mob.rotation) * 200)
	
func onGameStarted():
	print("Game started !")
	
	set_score(0)

	$DeadSound.stop()
	$Music.play()
	
	$Player.position = $StartPosition.position
	$Player.show()
	$MobTimer.start()
	$ScoreTimer.start()
	

func onGameOver() :
	print("Game over !")
	
	$Music.stop()
	$DeadSound.play()
	
	$Player.hide()
	
	$MobTimer.stop()
	$ScoreTimer.stop()
	
	cleanMobs()
	$Menu.GameOver()

func onScoreTimerTimeout() :
	$ScoreTimer.start()
	set_score(score + 1)







