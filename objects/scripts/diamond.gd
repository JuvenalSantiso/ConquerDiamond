extends Area2D

func _on_body_entered(body):
	if body.has_method("picked_diamond"): 
		body.picked_diamond()
		hide()
		
func spawn_diamond():
	show()
