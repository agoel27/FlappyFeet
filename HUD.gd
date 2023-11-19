extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game
signal single_player
signal multi_player

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Trash Crashers!"
	$Message.show()
	$Credits.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$StartButton2.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed():
	$Credits.hide()
	$StartButton.hide()
	$StartButton2.hide()
	single_player.emit()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()


func _on_start_button_2_pressed():
	$Credits.hide()
	$StartButton.hide()
	$StartButton2.hide()
	multi_player.emit()
	start_game.emit()
