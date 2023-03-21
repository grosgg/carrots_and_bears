extends StaticBody2D

signal display_key
signal give_key
signal open_dialog

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		for body in $DialogArea.get_overlapping_bodies():
			if body.is_in_group("player"):
				discuss(body)

func discuss(player):
	if player.carrots_count >= 10:
		give_key.emit()
		display_key.emit()
		open_dialog.emit("Thank you! Here is your key. Please say hello to your wife, he he!")
	else:
		open_dialog.emit("Give me 10 carrots and I will give you the spare key for your house, boy.")
