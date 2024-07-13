extends Node3D

@export var local_player_scene: PackedScene


func _ready() -> void:
	multiplayer.connected_to_server.connect(create_local_player)


func create_local_player() -> void:
	var player: CharacterBody3D = local_player_scene.instantiate()
	var peer_id: int = multiplayer.get_unique_id()
	player.name = str(peer_id)
	add_child(player)
	
	# This makes it so the ClientSync only sends property updates to the server and not other peers.
	var client_sync: MultiplayerSynchronizer = player.get_node("ClientSync")
	client_sync.set_multiplayer_authority(peer_id)
	client_sync.set_visibility_for(1, true)


func _on_player_spawner_spawned(node: Node) -> void:
	%Debug.add_visible_peer(node.name)


func _on_player_spawner_despawned(node: Node) -> void:
	%Debug.remove_visible_peer(node.name)

