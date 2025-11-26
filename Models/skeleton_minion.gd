extends Node3D

@onready var anim_player = $AnimationPlayer

func run():
	if anim_player:
		anim_player.play("Running_C")  # Juega directamente, asumiendo que existe

func idle():
	if anim_player:
		anim_player.play("Idle_Combat")  # Agrega una animación de idle si existe

func move():
	run()
