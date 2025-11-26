extends Node3D

@export var bullet_scene: PackedScene
@export var fire_rate: float = 2.0 # segundos entre disparos

@onready var muzzle = $Muzzle
@onready var timer = $Timer

func _ready():
	timer.wait_time = fire_rate
	timer.timeout.connect(_shoot)
	timer.start()

func _shoot():
	if not bullet_scene:
		return
		
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	# Posiciona la bala justo en el Muzzle
	bullet.global_position = muzzle.global_position
	bullet.global_rotation = muzzle.global_rotation
