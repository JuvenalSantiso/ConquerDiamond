extends Node

var peer: ENetMultiplayerPeer
var peer_dict: Dictionary


func create_game(host_data: Dictionary) -> int:
	var err = self.peer.create_server(host_data.port, host_data.max_players)
	if err != OK:
		return err
	self.peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.multiplayer_peer = self.peer
	
	print("Waiting For Players!")
	
	self.send_player_info(multiplayer.get_unique_id(), "Godkul1") ## TODO Cambiar esto
	
	return err


# Join an existing LAN game
func join_game(conn_data: Dictionary) -> int:
	var err = self.peer.create_client(conn_data.ip, conn_data.port.to_int())
	if err != OK:
		return err
	self.peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.multiplayer_peer = self.peer

	self.send_player_info(multiplayer.get_unique_id(), "Godkul2") ## TODO Cambiar esto

	return err


# Create a new peer using ENetMultiplayerPeer
func enable_peer() -> void:
	if !self.peer:
		self.peer = ENetMultiplayerPeer.new()
		multiplayer.peer_connected.connect(_on_peer_connected)
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)
		multiplayer.connected_to_server.connect(_on_connected_to_server)
		multiplayer.connection_failed.connect(_on_connection_failed)


# Delete the existing peer
func disable_peer() -> void:
	if self.peer:
		multiplayer.peer_connected.disconnect(_on_peer_connected)
		multiplayer.peer_disconnected.disconnect(_on_peer_disconnected)
		multiplayer.connected_to_server.disconnect(_on_connected_to_server)
		multiplayer.connection_failed.disconnect(_on_connection_failed)
		multiplayer.multiplayer_peer = null
		self.peer = null


# Deletes the specified peer from the list
func erase_peer(id: int) -> void:
	GameManager.remove_player(id)
	self.peer_dict.erase(id)
	var players = get_tree().get_nodes_in_group("Player")
	for player in players:
		if player.name == str(id):
			player.queue_free()


# Adds a new peer to the list
func add_peer(id, pname) -> void:
	var data = {
			"usr_name" : pname,
			"id" : id
		}
	if !self.peer_dict.has(data.id):
		self.peer_dict[data.id] = data


# Called on the host and clients when a new peer connects
func _on_peer_connected(id: int) -> void:
	print("Player Connected " + str(id))


# Called on the host and clients when a peer disconnects
func _on_peer_disconnected(id: int) -> void:
	print("Player Disconnected " + str(id))
	erase_peer(id)


# Called when the user successfully connects to a server
func _on_connected_to_server() -> void:
	print("connected To Sever!")


# Called when the users fails to connect to a server
func _on_connection_failed() -> void:
	print("Couldnt Connect")



# To be called from remote. Is given the id and information of a remote peer
@rpc("any_peer")
func send_player_info(id: int, usr_name: String) -> void:
	self.add_peer(id, usr_name)
	
	GameManager.add_player({"id": id, "usr_name": usr_name})
	
	if multiplayer.is_server():
		for player_id in self.peer_dict:
			self.send_player_info.rpc(player_id, peer_dict[player_id].usr_name)
