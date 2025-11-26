extends Node3D

@onready var anim_player = $AnimationPlayer

func run():
	if anim_player:
		anim_player.play("Running_A")  # Juega directamente, asumiendo que existe

func idle():
	if anim_player:
		anim_player.play("Idle_B")

func jump():
	if anim_player:
		anim_player.play("Jump_Full_Short")

func move():
	run()
