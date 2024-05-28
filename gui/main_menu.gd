extends Control


func _on_play_button_up():
	$IP.show()
	$VBoxContainer.hide()



func _on_host_button_up():
	GameManager.init_host()
	GameManager.init_game()
