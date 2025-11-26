extends Control

@onready var new_game_btn = $VBoxContainer/NuevaPartida
@onready var load_game_btn = $VBoxContainer/CargarPartida
@onready var options_btn = $VBoxContainer/Opciones
@onready var exit_btn = $VBoxContainer/Salir

func _ready():
	new_game_btn.pressed.connect(_on_new_game_pressed)
	load_game_btn.pressed.connect(_on_load_game_pressed)
	options_btn.pressed.connect(_on_options_pressed)
	exit_btn.pressed.connect(_on_exit_pressed)

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://game.tscn")

func _on_load_game_pressed():
	var save_data = SaveManager.load_game()
	if save_data:
		# Cambiar a la escena guardada
		get_tree().change_scene_to_file(save_data["current_scene"])
		# Nota: Para restaurar posición, necesitas un script en la escena cargada (ver abajo)
	else:
		print("No hay partida guardada")

func _on_options_pressed():
	print("Opciones (aún no implementadas)")

func _on_exit_pressed():
	get_tree().quit()
