extends StaticBody2D

enum STATE { PLAY, IDLE }

@onready var animation_player = $AnimationPlayer
@onready var trigger = $Trigger

signal open_dialog
signal love_wife

var current_state : STATE = STATE.PLAY

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		for body in trigger.get_overlapping_bodies():
			if body.is_in_group("player"):
				open_dialog.emit("Welcome home, darling!\nI missed you so much!")
				love_wife.emit()

func _ready():
	animation_player.play("play")	

# Set status
func set_play():
	current_state = STATE.PLAY
	animation_player.play("play")

func set_idle():
	current_state = STATE.IDLE
	animation_player.play("idle")
