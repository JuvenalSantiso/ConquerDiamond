extends Node

signal start_diamond_picked

var _PORT: int = 5820

var players = {}
@export var player_scene: PackedScene = preload("res://player/player.tscn")

func init_host():
	NetworkManager.enable_peer()
	var host_data = {"port": _PORT, "max_players": 2}
	NetworkManager.create_game(host_data)
	

func init_join(connection_ip: String):
	NetworkManager.enable_peer()
	var ip_dict = _parse_ip(connection_ip)
	var err = NetworkManager.join_game(ip_dict)
	if err != OK:
		return

func init_game():
	get_tree().change_scene_to_file("res://levels/level_raw.tscn")

func _parse_ip(connection_ip):
	var ip = connection_ip.split(':')
	return {'ip': ip[0], 'port': ip[1]}

#Player functions
func spawn_player(data):
	var p = player_scene.instantiate()
	p.player_picked_diamond.connect(Callable(self, "_diamond_picked"))
	p.set_multiplayer_authority(data)
	players[data] = p
	return p

func remove_player(id):
	players.erase(id)
	
func diamond_sets():
	for id in self.players:
		if players[id].has_diamond:
			winner(id)
			break

func winner(id):
	print(id, " WINNER")
	
func _diamond_picked(id):
	print(id, "Picked a diamond")
	start_diamond_picked.emit()


