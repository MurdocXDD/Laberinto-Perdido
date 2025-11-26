extends "res://EnemyBase.gd"

@export var jump_force: float = 10.0
@export var gravity: float = 20.0
@export var jump_interval: float = 1.0  # Reducido para saltos más frecuentes
@export var chase_speed: float = 5.0  # Velocidad de persecución
@export var rotation_speed: float = 8.0  # Velocidad de rotación hacia el jugador

var time_since_jump := 0.0
@onready var player = get_node("../Player3DTemplate")  # Ajusta la ruta si es diferente
@onready var _skin: Node3D = $Skeleton_Warrior

func _physics_process(delta):
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Persecución en 3D: mover hacia el jugador en X y Z
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity.x = direction.x * chase_speed
		velocity.z = direction.z * chase_speed  # Agregado para persecución en Z
		
		# Rotación hacia el jugador
		var target_angle = Vector3.BACK.signed_angle_to(direction, Vector3.UP)
		_skin.global_rotation.y = lerp_angle(_skin.global_rotation.y, target_angle, rotation_speed * delta)
	
	# Saltos más frecuentes (solo si está en el suelo)
	time_since_jump += delta
	if time_since_jump >= jump_interval and is_on_floor():
		velocity.y = jump_force
		time_since_jump = 0.0

	move_and_slide()

	# --- ANIMACIONES ---
	var ground_speed := Vector2(velocity.x, velocity.z).length()
	if ground_speed > 0.0:
		_skin.move()  # Reproducir animación de caminar
	else:
		# Opcional: Agregar idle si el skin lo tiene
		if _skin.has_method("idle"):
			_skin.idle()

func _on_area_3d_body_entered(body):
	if body.name == "Player3DTemplate":
		print("💥 El saltador dañó al jugador")
		var hud = get_tree().current_scene.get_node_or_null("HUD")
		if hud:
			hud.take_damage(15)
