extends Node3D

signal collected
@onready var coin_sound = $CoinSound
@onready var area = $Area3D

func _ready():
	area.body_entered.connect(_on_body_entered)

func _process(delta):
	rotate_y(delta * 2.0) # Gira la moneda

func _on_body_entered(body):
	print("Algo entró al área:", body.name)
	if body.name == "Player3DTemplate":
		print("¡Moneda recogida!")
		emit_signal("collected")

		# ✅ Reproducir sonido antes de borrar la moneda
		if coin_sound:
			coin_sound.play()

		# ✅ Esperar a que el sonido termine antes de eliminar la moneda
		await coin_sound.finished

		queue_free()
