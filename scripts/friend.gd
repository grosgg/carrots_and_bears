extends CharacterBody2D

enum STATE { PLAY, RUN }

@export var run_speed : float = 50

@onready var animation_player = $AnimationPlayer

var move_direction : Vector2 = Vector2(-1, 0)
var current_state : STATE = STATE.PLAY

func _ready():
	set_play()
	
func _physics_process(_delta):
	if (current_state == STATE.RUN):
		run()

# Move
func run():
	if position.x < 16: queue_free()
	velocity = move_direction * run_speed
	move_and_slide()

# Set status
func set_play():
	current_state = STATE.PLAY
	animation_player.play("play")

func set_run():
	current_state = STATE.RUN
	animation_player.play("run")
