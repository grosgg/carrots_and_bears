extends CharacterBody2D

@export var move_speed : float = 50
@export var health : int = 10
@export var carrots_count : int = 0
@export var has_key : bool = false

@onready var actionable_area = $ActionableArea
@onready var detection_area = $DetectionArea
@onready var lifted_carrot = $LiftedCarrot
@onready var animation_player = $AnimationPlayer
@onready var hurt_sound = $HurtSound
@onready var pick_sound = $PickSound

signal toggle_interact_help
signal take_damage
signal carrot_picked
signal enter_combat
signal exit_combat

func _physics_process(_delta):
	var input_direction : Vector2

	if animation_player.current_animation == "lift":
		return
	
	# Set input direction
	input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

	# Update velocity
	velocity = input_direction * move_speed
	
	#Move and slide
	move_and_slide()
	pick_new_state()

func pick_new_state():
	if (velocity != Vector2.ZERO):
		animation_player.play("walk")
	else:
		animation_player.play("idle")

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		for body in actionable_area.get_overlapping_bodies():
			if body.is_in_group("carrots"):
				pickCarrot(body)

func pickCarrot(carrot):
	pick_sound.play()
	carrots_count += 1
	carrot_picked.emit(carrots_count)
	carrot.queue_free()
	animation_player.play("lift")

func _on_animation_player_animation_started(anim_name):
	if anim_name == "lift":
		lifted_carrot.show()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "lift":
		lifted_carrot.hide()

func _on_actionable_area_body_entered(body):
	if body.is_in_group("carrots"):
		toggle_interact_help.emit()
	elif body.is_in_group("jiji"):
		toggle_interact_help.emit()
	elif body.is_in_group("doors"):
		toggle_interact_help.emit()
	elif body.is_in_group("bears"):
		hurt_sound.play()
		take_damage.emit()
		body.get_parent().pause()

func _on_actionable_area_body_exited(body):
	if body.is_in_group("carrots"):
		toggle_interact_help.emit()
	elif body.is_in_group("jiji"):
		toggle_interact_help.emit()
	elif body.is_in_group("doors"):
		toggle_interact_help.emit()
	elif body.is_in_group("bears"):
		body.get_parent().set_rage()

func _on_jiji_give_key():
	has_key = true
	pick_sound.play()

func _on_detection_area_body_entered(body):
	if body.is_in_group("bears"): enter_combat.emit()

func _on_detection_area_body_exited(body):
	if body.is_in_group("bears"):
		var is_bear_remaining = false
		for remaining in detection_area.get_overlapping_bodies():
			if remaining.is_in_group("bears"): is_bear_remaining = true
		if !is_bear_remaining:
			exit_combat.emit()
