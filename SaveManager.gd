extends Node

const SAVE_PATH = "user://savegame.json"

# Función para guardar el estado del juego
func save_game(player_position: Vector3, current_scene: String, extra_data: Dictionary = {}):
	var save_data = {
		"player_position": {
			"x": player_position.x,
			"y": player_position.y,
			"z": player_position.z
		},
		"current_scene": current_scene,
		"extra_data": extra_data
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("💾 Juego guardado")
	else:
		print("❌ Error al guardar")

# Función para cargar el estado del juego
func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("❌ No hay partida guardada")
		return null
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var save_data = JSON.parse_string(file.get_as_text())
		file.close()
		if save_data:
			var player_pos = Vector3(save_data["player_position"]["x"], save_data["player_position"]["y"], save_data["player_position"]["z"])
			var scene = save_data["current_scene"]
			var extra = save_data.get("extra_data", {})
			print("📂 Partida cargada")
			return {"player_position": player_pos, "current_scene": scene, "extra_data": extra}
	return null
