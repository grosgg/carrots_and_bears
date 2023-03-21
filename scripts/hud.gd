extends Node

signal start_bgm

# Welcome title
func _on_title_timer_ready():
	$Welcome/TitleTimer.start()

func _on_title_timer_timeout():
	$Welcome.hide()
	start_bgm.emit()

# Carrots
func _on_player_toggle_interact_help():
	$HelpPanel.visible = !$HelpPanel.visible

func _on_player_carrot_picked(carrots_count):
	$ScorePanel/CarrotValue.text = str(carrots_count)

# Jiji
func _on_jiji_display_key():
	$ScorePanel/CarrotLabel.hide()
	$ScorePanel/CarrotValue.hide()
	$ScorePanel/KeyLabel.show()

# Damage
func takeDamage():
	$ScorePanel/ProgressBar.value -= 1
	if $ScorePanel/ProgressBar.value == 0:
		gameOver()

func _on_player_take_damage():
	takeDamage()

# Game Over
func gameOver():
	$GameOver.show()
	$GameOver/GameOverTimer.start()

func _on_game_over_timer_timeout():
	get_tree().reload_current_scene()
