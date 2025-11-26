extends Node3D

@onready var anim_player = $AnimationPlayer

func run():
	if anim_player:
		anim_player.play("Walking_Backwards")  # Juega directamente, asumiendo que existe

func idle():
	if anim_player:
		anim_player.play("Idle_B")  # Agrega una animación de idle si existe (ej. "Idle_B" si es como el personaje principal)

func move():
	run()
