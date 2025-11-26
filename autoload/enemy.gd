extends CharacterBody3D

@export var speed: float = 2.0
@export var move_distance: float = 5.0
@export var max_health: int = 50  # Vida máxima del enemigo
var current_health: int

@onready var start_position = global_position
var direction = 1

func _ready():
	current_health = max_health

func _physics_process(delta):
	# Movimiento horizontal
	velocity = Vector3(direction * speed, 0, 0)
	move_and_slide()

	# Cambiar dirección al alcanzar los límites del patrullaje
	if abs(global_position.x - start_position.x) > move_distance:
		direction *= -1
		scale.x = direction

func _on_area_3d_body_entered(body):
	if body.name == "Player3DTemplate":
		print("¡Golpeó al jugador!")
		var hud = get_tree().current_scene.get_node_or_null("HUD")
		if hud:
			hud.take_damage(20)

# --- NUEVO: tomar daño ---
func take_damage(amount: int):
	current_health -= amount
	print("Enemigo recibió daño:", amount, "Vida restante:", current_health)
	if current_health <= 0:
		die()

func die():
	print("Enemigo muerto")
	queue_free()
