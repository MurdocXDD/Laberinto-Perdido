extends Area3D

@onready var coin_sound = $CoinSound

# Esta función se ejecuta cuando un cuerpo de física (como el CharacterBody3D del jugador) entra en el Area3D.
func _on_body_entered(body):
	# Paso 1: Verificar si el cuerpo que colisionó está en el grupo "player".
	# Esto evita que el objeto desaparezca si choca con una pared u otro objeto.
	if body.is_in_group("player"):
		
		# Paso 2: Activar la lógica del efecto en el jugador.
		# Es crucial usar 'call_deferred()' para evitar errores de Godot
		# que ocurren a veces al llamar a funciones mientras una colisión está en progreso.
		if body.has_method("activar_salto_extra"):
			body.call_deferred("activar_salto_extra")
			if coin_sound:
				coin_sound.play()
			await coin_sound.finished
		
		# Paso 3: Eliminar el objeto Power-Up de la escena.
		queue_free()
