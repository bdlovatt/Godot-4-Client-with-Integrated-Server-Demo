extends Node3D

@onready var server_sync: MultiplayerSynchronizer = $ServerSync
@onready var client_sync: MultiplayerSynchronizer = $ClientSync

# NOTE: ClientSync updates Player position, and ServerSync then broadcasts that position to all visible peers.

# NOTE: As you can see, there are two Area3Ds in this scene.
# ClientVisibility:
# the visibility radius for the client. It doesn't detect anything. instead, ServerAreas will detect when it
# enters/exits them.

# ServerArea:
# detects when a ClientVisibility area enters/exits it. It can then call "set_visibility_for" on ServerSync. What
# happens here is that since Player and ServerSync both have a multiplayer_authority of 1 (server), the server-side
# PlayerSpawner detects that ServerSync can now see a peer, so it tells that peer to spawn a "puppet player" scene.

# NOTE: ClientSync has to have public_visibility set to false, otherwise the PlayerSpawner in main scene will try
# to spawn a puppet player on a client with the same name as the client's locally created player.

func _on_server_area_area_entered(client_visibility_area: Area3D) -> void:
	if client_visibility_area == $ClientVisibility:
		return
	
	var peer_id: int = client_visibility_area.get_multiplayer_authority()
	server_sync.set_visibility_for(peer_id, true)


func _on_server_area_area_exited(client_visibility_area: Area3D) -> void:
	if client_visibility_area == $ClientVisibility:
		return
	
	var peer_id: int = client_visibility_area.get_multiplayer_authority()
	server_sync.set_visibility_for(peer_id, false)

