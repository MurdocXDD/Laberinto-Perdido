extends Node

@onready var hud = $HUD

func _ready():
	# Buscar todas las monedas en la escena (pueden estar en subnodos)
	var coins = get_tree().get_nodes_in_group("coins")

	for coin in coins:
		if not coin.is_connected("collected", Callable(hud, "_on_coin_collected")):
			coin.connect("collected", Callable(hud, "_on_coin_collected"))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		get_viewport().mode = (
			Window.MODE_FULLSCREEN if
			get_viewport().mode != Window.MODE_FULLSCREEN else
			Window.MODE_WINDOWED
		)

func _process(delta):
	hud.update_timer(delta)
