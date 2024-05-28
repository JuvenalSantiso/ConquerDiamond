extends Node

var _PORT: int = 5820
var players = {}
@export var player_scene: PackedScene = preload("res://player/player.tscn")

func init_host():
	NetworkManager.enable_peer()
	var host_data = {"port": _PORT, "max_players": 2}
	NetworkManager.create_game(host_data)

func init_game():
	get_tree().change_scene_to_file("res://levels/level_raw.tscn")


#Player functions
func spawn_player(data):
	var p = player_scene.instantiate()
	p.set_multiplayer_authority(data)
	players[data] = p
	return p


func add_player(data):
	if !self.players.has(data.id):
		self.players[data.id] = {
			"usr_name" : data.usr_name,
			"id" : data.id,
			"score": 0
		}

func remove_player(id):
	players.erase(id)


