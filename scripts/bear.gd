extends CharacterBody2D

enum STATE { IDLE, WALK, RAGE }

@export var walk_speed : float = 10
@export var rage_speed : float = 30
@export var idle_time : float = randi_range(3, 6)
@export var walk_time : float = randi_range(1, 5)
@export var paused : bool = false

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var pause_timer = $PauseTimer
@onready var detection_area = $DetectionArea

var move_direction : Vector2 = Vector2.ZERO
var current_state : STATE = STATE.IDLE

func _ready():
	select_new_direction()
	pick_new_state()
	
func _physics_process(_delta):
	if paused: return

	if (current_state == STATE.WALK):
		walk()
	elif (current_state == STATE.RAGE):
		for body in detection_area.get_overlapping_bodies():
			if body.is_in_group("player"):
				rage(body)
	
func select_new_direction():
	move_direction = Vector2(
		randi_range(-1, 1),
		randi_range(-1, 1)
	)

func pick_new_state():
	if (current_state == STATE.IDLE):
		set_walk()
		select_new_direction()
		timer.start(walk_time)
	else:
		set_idle()
		timer.start(idle_time)

func _on_timer_timeout():
	if current_state != STATE.RAGE:
		pick_new_state()

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"): set_rage()

func _on_detection_area_body_exited(body):
	if body.is_in_group("player"): set_idle()

# Move
func walk():
	velocity = move_direction * walk_speed
	move_and_slide()

func rage(body):
	velocity = (body.position - position).normalized() * rage_speed
	move_and_slide()

func pause():
	paused = true
	set_idle()
	pause_timer.start()

# Set status
func set_idle():
	current_state = STATE.IDLE
	animation_player.play("idle")

func set_walk():
	current_state = STATE.WALK
	animation_player.play("walk")

func set_rage():
	current_state = STATE.RAGE
	animation_player.play("rage")

func _on_pause_timer_timeout():
	paused = false
