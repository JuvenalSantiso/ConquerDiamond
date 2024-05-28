# Inheritance
extends MultiplayerSpawner

# Signals

# Constants

# Public Variables

# Private Variables
var _ready_player_count: int = 0

# Godot Methods
func _ready():
	spawn_function = PlayersManager.spawn_player
	if multiplayer.is_server():
		is_all_players_ready()
	else:
		rpc_id(1,"is_all_players_ready")


# Public Methods

# Private Methods

# Godot Signal Methods

# Custom Signal Methods
@rpc("any_peer")
func is_all_players_ready():
	_ready_player_count = _ready_player_count + 1
	if _ready_player_count == PlayersManager.players.size() and multiplayer.is_server():
		for player in PlayersManager.players:
			spawn(player)
