extends CharacterBody3D

@export var health: int = 50
@onready var death_sound: AudioStreamPlayer3D = $DeathSound

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func die():
	if death_sound:
		death_sound.play()  # reproduce el sonido
	# espera un poco para que suene antes de eliminar
	await get_tree().create_timer(0.3).timeout
	queue_free()
