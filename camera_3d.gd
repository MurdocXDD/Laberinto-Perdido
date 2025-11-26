extends Camera3D

@export var player: Node3D
@export var height: float = 13
@export var rotate_with_player: bool = false

func _process(delta: float) -> void:
	if player == null:
		return

	# --- POSICIÓN DE LA CÁMARA ---
	var ppos = player.global_position
	
	# colocar la cámara arriba del jugador
	global_position = Vector3(ppos.x, ppos.y + height, ppos.z)

	# --- ORIENTACIÓN ---
	if rotate_with_player:
		# obtenemos rotación Y del jugador
		var yaw = player.global_rotation.y

		# mirar hacia abajo + yaw del jugador
		rotation = Vector3(-PI/2, yaw, 0)
	else:
		# minimapa con norte fijo
		rotation = Vector3(-PI/2, 0, 0)
