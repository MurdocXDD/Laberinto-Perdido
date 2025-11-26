extends Node3D

@onready var anim_player = $AnimationPlayer

func run():
	if anim_player and anim_player.has_animation("Run"):
		anim_player.play("Run")

func idle():
	if anim_player and anim_player.has_animation("Idle"):
		anim_player.play("Idle_B")

func jump():
	if anim_player and anim_player.has_animation("Jump2"):
		anim_player.play("Jump_Full_Short")

func fall():
	if anim_player and anim_player.has_animation("Fall"):
		anim_player.play("Fall")

func move():
	run()

func attack():
	if anim_player and anim_player.has_animation("Kick"):
		anim_player.play("Kick")
	else:
		print("❌ Animación 'Kick' no encontrada")
