extends CanvasLayer

signal game_started

# Declare member variables here. Examples:
var started : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartButton.connect("pressed", self, "onStartButtonPressed")
	$RestartTimer.connect("timeout", self, "onRestartTimerTimeout")
	started = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if not started and Input.is_key_pressed(32) : # space key
	#	onStartButtonPressed()
	pass

func onStartButtonPressed() :
	started = true
	$MessageLabel.hide()
	$StartButton.hide()
	emit_signal("game_started")
	
func UpdateScore(score: int) :
	$ScoreLabel.text = str(score)
	
func GameOver() :
	$MessageLabel.text = "GAME OVER"
	$MessageLabel.show()
	$RestartTimer.start()

func onRestartTimerTimeout() :
	$RestartTimer.stop()
	$MessageLabel.text = "Dodge The Creeps"
	$StartButton.show()
	started = false

