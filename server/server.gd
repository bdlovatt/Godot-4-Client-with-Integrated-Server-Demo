class_name Server
extends Node

@export var port = 9001


func _enter_tree() -> void:
	# This lets us use this node as the root for multiplayer. Basically, "Server" becomes the root for all NodePaths when
	# using RPCs or the MultiplayerSynchronizer/Spawner nodes. So any node above it gets ignored as far as multiplayer
	# is concerned.
	get_tree().set_multiplayer(MultiplayerAPI.create_default_interface(), self.get_path())


func _ready() -> void:
	host()


func host() -> void:
	var enet_multiplayer_peer = ENetMultiplayerPeer.new()
	var check: Error = enet_multiplayer_peer.create_server(port)
	match check:
		OK:
			multiplayer.multiplayer_peer = enet_multiplayer_peer
			%Debug.set_multiplayer_mode(true)
		
		_:
			# NOTE: If enet_multiplayer_peer can't create a server, then it will push an error. This is happening
			# because a another client has already created a server on the above port.
			%Debug.set_multiplayer_mode(false)
			return get_parent().queue_free()
	
	multiplayer.peer_connected.connect(
		func(peer_id: int):
			print("[%s]: New peer connected! peer_id: %s." % [name, str(peer_id)])
	)
	multiplayer.peer_disconnected.connect(
		func(peer_id: int):
			print("[%s]: Peer disconnected. peer_id: %s." % [name, str(peer_id)])
	)

