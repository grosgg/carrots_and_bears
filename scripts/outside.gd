extends Node2D

@onready var house_entrance_trigger = $HouseEntrance/Trigger
@onready var bgm = $BGM
@onready var combat_music = $CombatMusic

signal open_dialog

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		for body in house_entrance_trigger.get_overlapping_bodies():
			if body.is_in_group("player"):
				enter_house(body)

func enter_house(player):
	if player.has_key:
		get_tree().change_scene_to_file("res://scenes/house.tscn")
	else:
		open_dialog.emit("The door is locked.")

func _on_hud_start_bgm():
	bgm.play()

func _on_bgm_finished():
	bgm.play()

func _on_combat_music_finished():
	combat_music.play()

func _on_player_enter_combat():
	if bgm.playing:
		bgm.playing = false
		combat_music.play()

func _on_player_exit_combat():
	if combat_music.playing:
		combat_music.playing = false
		bgm.play()

