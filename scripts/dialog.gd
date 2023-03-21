extends Node

signal dialog_close

func _on_dialog_timer_timeout():
	$DialogPanel.hide()
	dialog_close.emit()

func displayDialog(text):
	$DialogPanel/Message.text = text
	$DialogPanel.show()
	$DialogPanel/DialogTimer.start()

func _on_jiji_open_dialog(text):
	displayDialog(text)

func _on_outside_open_dialog(text):
	displayDialog(text)

func _on_house_open_dialog(text):
	displayDialog(text)

func _on_wife_open_dialog(text):
	displayDialog(text)
