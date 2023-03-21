extends Node2D

@export var door_knocked : bool = false
@export var door_opened : bool = false
@export var wife_loved : bool = false

@onready var bedroom_door = $BedroomDoor
@onready var bedroom_door_trigger = $BedroomDoor/Trigger
@onready var door_timer = $DoorTimer
@onready var the_end = $TheEnd
@onready var the_end_timer = $TheEnd/EndTimer

@onready var friend1 = $Friend1
@onready var friend2 = $Friend2
@onready var friend3 = $Friend3
@onready var wife = $Wife
@onready var bgm = $BGM
@onready var fade_in = $FadeIn

signal open_dialog

func _ready():
	var bgm_tween = get_tree().create_tween()
	bgm_tween.tween_property(bgm, "volume_db", 0, 3)
	
	var fade_in_tween = get_tree().create_tween()
	fade_in_tween.tween_property(fade_in, "color", Color(0, 0, 0, 0.8), 3)
	fade_in_tween.tween_property(fade_in, "color", Color(0, 0, 0, 0), 2)
	
	bgm.play(7)

func _unhandled_input(event):
	if event.is_action_pressed("interact") && !door_opened:
		for body in bedroom_door_trigger.get_overlapping_bodies():
			if body.is_in_group("player"):
				enter_room()

func enter_room():
	if(!door_knocked): 
		door_knocked = true
		open_dialog.emit("Oh honey, you're home? Just 2 seconds...")
		friend1.set_run()
		friend2.set_run()
		friend3.set_run()
		wife.set_idle()
		bgm.volume_db = -12
		door_timer.start()
	

func _on_door_timer_timeout():
	if(!door_opened): 
		door_opened = true
		bedroom_door.queue_free()

func _on_end_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/outside.tscn")

func _on_dialog_dialog_close():
	if wife_loved:
		the_end.show()
		the_end_timer.start()

func _on_wife_love_wife():
	wife_loved = true

func _on_bgm_finished():
	bgm.play()
