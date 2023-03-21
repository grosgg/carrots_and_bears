extends CharacterBody2D

enum STATE { IDLE, WALK }

@export var move_speed : float = 10
@export var idle_time : float = randi_range(3, 6)
@export var walk_time : float = randi_range(1, 5)

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var timer = $Timer

var move_direction : Vector2 = Vector2.ZERO
var current_state : STATE = STATE.IDLE

func _ready():
	select_new_direction()
	pick_new_state()
	
func _physics_process(_delta):
	if (current_state == STATE.WALK):
		velocity = move_direction * move_speed
		move_and_slide()
	
func select_new_direction():
	move_direction = Vector2(
		randi_range(-1, 1),
		randi_range(-1, 1)
	)
	
	if (move_direction.x < 0):
		sprite.flip_h = true;
	elif (move_direction.x > 0):
		sprite.flip_h = false;

func pick_new_state():
	if (current_state == STATE.IDLE):
		current_state = STATE.WALK
		animation_player.play("walk")
		select_new_direction()
		timer.start(walk_time)
	else:
		current_state = STATE.IDLE
		animation_player.play("idle")
		timer.start(idle_time)

func _on_timer_timeout():
	pick_new_state()
