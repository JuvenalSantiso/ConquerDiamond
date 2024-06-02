extends Control

@onready var ip_text: LineEdit = $IP/HBoxContainer/IPEdit

func _on_play_button_up():
	$IP.show()
	$VBoxContainer.hide()



func _on_host_button_up():
	GameManager.init_host()
	GameManager.init_game()


func _on_go_button_up():
	#GameManager.init_join(ip_text.text)
	GameManager.init_join("127.0.0.1:5820")
	GameManager.init_game()
