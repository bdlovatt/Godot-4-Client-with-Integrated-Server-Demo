extends Node3D

@export var server_player_scene: PackedScene


func _ready() -> void:
	multiplayer.peer_connected.connect(
		func(peer_id: int):
			var player: Node3D = server_player_scene.instantiate()
			player.name = str(peer_id)
			add_child(player)
			
			# Allows other server player nodes to see which peer this visibility area belongs to.
			var client_visibility_area: Area3D = player.get_node("ClientVisibility")
			client_visibility_area.set_multiplayer_authority(peer_id)
			
			# Allows recieving property updates from the node's owning client.
			var client_sync: MultiplayerSynchronizer = player.get_node("ClientSync")
			client_sync.set_multiplayer_authority(peer_id)
			
			# Avoids sending property updates back to the node's owning client.
			var server_sync: MultiplayerSynchronizer = player.get_node("ServerSync")
			server_sync.set_visibility_for(peer_id, false)
	)
	multiplayer.peer_disconnected.connect(
		func(peer_id: int):
			get_node(str(peer_id)).queue_free()
	)
