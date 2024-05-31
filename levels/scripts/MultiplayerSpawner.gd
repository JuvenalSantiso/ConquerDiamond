# Inheritance
extends MultiplayerSpawner

func _ready():
	spawn_function = GameManager.spawn_player
	if is_multiplayer_authority():
		spawn(1)
		multiplayer.peer_connected.connect(spawn)
		multiplayer.peer_disconnected.connect(GameManager.remove_player)
