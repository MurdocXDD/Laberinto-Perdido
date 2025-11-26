extends "res://EnemyBase.gd"

@export var speed: float = 4.0          # velocidad al perseguir
@export var return_speed: float = 2.0   # velocidad para regresar
@export var chase_distance: float = 10.0
@export var rotation_speed: float = 8.0  # Opcional: velocidad de rotación hacia el target

@onready var start_position = global_position
@onready var vision_area = $VisionArea
@onready var damage_area = $DamageArea
@onready var _skin: Node3D = $Skeleton_Minion 

var chasing = false
var returning = false
var target: Node3D = null

func _ready():
	# Conectar señales del área de visión y daño
	vision_area.body_entered.connect(_on_vision_entered)
	vision_area.body_exited.connect(_on_vision_exited)
	damage_area.body_entered.connect(_on_damage_entered)

func _physics_process(delta):
	if chasing and target:
		# Persigue al jugador
		var direction = (target.global_position - global_position).normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		# Opcional: Rotación hacia el target
		if _skin:
			var target_angle = Vector3.BACK.signed_angle_to(direction, Vector3.UP)
			_skin.global_rotation.y = lerp_angle(_skin.global_rotation.y, target_angle, rotation_speed * delta)
		
		# Animación de movimiento
		if _skin:
			_skin.move()
	elif returning:
		# Regresa a su posición original
		var dir_back = (start_position - global_position)
		if dir_back.length() > 0.1:
			velocity = dir_back.normalized() * return_speed
			# Animación de movimiento al regresar
			if _skin:
				_skin.move()
		else:
			velocity = Vector3.ZERO
			returning = false
			# Animación de idle al llegar
			if _skin:
				_skin.idle()
	else:
		# Quieto si no ve al jugador
		velocity = Vector3.ZERO
		# Animación de idle
		if _skin:
			_skin.idle()

	move_and_slide()

func _on_vision_entered(body):
	if body.name == "Player3DTemplate":
		print("👀 Jugador detectado, persiguiendo")
		chasing = true
		returning = false
		target = body

func _on_vision_exited(body):
	if body == target:
		print("❌ Jugador fuera de rango, regresando")
		chasing = false
		returning = true
		target = null

func _on_damage_entered(body):
	if body.name == "Player3DTemplate":
		print("💥 Jugador dañado por enemigo")
		var hud = get_tree().current_scene.get_node_or_null("HUD")
		if hud:
			hud.take_damage(20)
