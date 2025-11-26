extends CharacterBody3D

@export var fall_limit: float = -100.0
@export var game_over_scene: PackedScene

# --- MOVIMIENTO ---
@export_group("Movement")
#@export var move_speed := 8.0
@export var acceleration := 20.0
@export var jump_impulse : float = 12.0
var jump_impulse_actual : float = jump_impulse
@export var rotation_speed := 4.0
@export var stopping_speed := 1.0
@export var velocidad_base: float = 6.0
var velocidad_actual: float = velocidad_base

# --- CÁMARA ---
@export_group("Camera")
@export_range(0.0, 0.5) var mouse_sensitivity := 0.25
@export var tilt_upper_limit := PI / 3.0
@export var tilt_lower_limit := -PI / 8.0

var ground_height := 0.0
var _gravity := -30.0
var _was_on_floor_last_frame := true
var _camera_input_direction := Vector2.ZERO
@onready var _last_input_direction := global_basis.z
@onready var _start_position := global_position

# --- NODOS ---
@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _camera: Camera3D = %Camera3D
@onready var _skin: Node3D = $Skeleton_Mage
@onready var _dust_particles: GPUParticles3D = %DustParticles
@onready var _landing_sound: AudioStreamPlayer3D = %LandingSound
@onready var _jump_sound: AudioStreamPlayer3D = %JumpSound
@onready var _attack_area: Area3D = $AttackArea
@onready var _walk_sound: AudioStreamPlayer3D = %WalkSound  # Nuevo nodo para sonido de caminar

# --- ATAQUE ---
var _is_attacking = false

func _ready() -> void:
	# Conectar señales de eventos (ejemplo: planes que matan)
	Events.kill_plane_touched.connect(func():
		global_position = _start_position
		velocity = Vector3.ZERO
		_skin.idle()
		set_physics_process(true)
	)
	Events.flag_reached.connect(func():
		set_physics_process(false)
		_skin.idle()
		_dust_particles.emitting = false
	)

	# Conectar señal del área de ataque
	_attack_area.body_entered.connect(_on_attack_area_body_entered)
	_attack_area.monitoring = false
	if SaveManager:
		SaveManager.save_game(global_position, get_tree().current_scene.scene_file_path)
	else:
		print("SaveManager no encontrado")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		print("¡Clic detectado!")
		_attack()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_camera_input_direction.x = -event.relative.x * mouse_sensitivity
		_camera_input_direction.y = -event.relative.y * mouse_sensitivity

func _physics_process(delta: float) -> void:
	# --- CÁMARA ---
	# Hacer que la cámara siga la rotación del personaje en Y
	_camera_pivot.rotation.y = lerp_angle(_camera_pivot.rotation.y, _skin.global_rotation.y, rotation_speed * delta)
	
	# Rotación adicional con el mouse
	_camera_pivot.rotation.x += _camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, tilt_lower_limit, tilt_upper_limit)
	_camera_pivot.rotation.y += _camera_input_direction.x * delta
	_camera_input_direction = Vector2.ZERO

	# --- MOVIMIENTO ---
	var raw_input := Input.get_vector("move_left", "move_right", "move_up", "move_down", 0.4)
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x
	var move_direction := (forward * raw_input.y + right * raw_input.x).normalized()
	move_direction.y = 0

	if move_direction.length() > 0.2:
		_last_input_direction = move_direction

	var target_angle := Vector3.BACK.signed_angle_to(_last_input_direction, Vector3.UP)
	_skin.global_rotation.y = lerp_angle(_skin.rotation.y, target_angle, rotation_speed * delta)

	var y_velocity := velocity.y
	velocity.y = 0
	velocity = velocity.move_toward(move_direction * velocidad_actual, acceleration * delta)
	if is_equal_approx(move_direction.length_squared(), 0.0) and velocity.length_squared() < stopping_speed:
		velocity = Vector3.ZERO
	velocity.y = y_velocity + _gravity * delta

	# --- ANIMACIONES ---
	if _is_attacking:
		pass
	else:
		var ground_speed := Vector2(velocity.x, velocity.z).length()
		var is_just_jumping := Input.is_action_just_pressed("jump") and is_on_floor()
		if is_just_jumping:
			velocity.y += jump_impulse_actual
			_skin.jump()
			_jump_sound.play()
		
		elif is_on_floor():
			if ground_speed > 0.0:
				_skin.move()
				# Reproducir sonido de caminar en bucle
				if not _walk_sound.playing:
					_walk_sound.play()
			else:
				_skin.idle()
				# Detener sonido de caminar
				_walk_sound.stop()

		_dust_particles.emitting = is_on_floor() and ground_speed > 0.0

	if is_on_floor() and not _was_on_floor_last_frame:
		_landing_sound.play()

	_was_on_floor_last_frame = is_on_floor()
	move_and_slide()

	# Checar si caí más allá del límite
	if global_position.y < fall_limit:
		get_tree().change_scene_to_packed(game_over_scene)

# --- ATAQUE ---
func _attack() -> void:
	if _is_attacking:
		return
	_is_attacking = true

	# Reproducir animación
	#_skin.attack()  

	# Activar área de ataque durante la duración de la animación
	var kick_length = 0.5  # Cambia este valor a la duración real de tu animación Kick
	if _skin.anim_player and _skin.anim_player.has_animation("Kick"):
		kick_length = _skin.anim_player.get_animation("Kick").length

	_attack_area.monitoring = true
	await get_tree().create_timer(kick_length).timeout
	_attack_area.monitoring = false

	# Cooldown opcional
	await get_tree().create_timer(0.3).timeout
	_is_attacking = false

func _on_attack_area_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(100)



#Esto hace funcionar el script de ve
#@export var velocidad_base: float = 5.0
#var velocidad_actual: float = velocidad_base

# Añade un Timer a tu CharacterBody3D en el Árbol de Escenas y conecta su señal 'timeout'
@onready var timer_power_up = $TimerPowerUp 

func activar_velocidad_extra():
	# Aumenta la velocidad del jugador
	velocidad_actual = velocidad_base * 3 
	timer_power_up.start(5.0) # El efecto dura 5 segundos

func _on_timer_power_up_timeout():
	# Vuelve a la velocidad normal
	velocidad_actual = velocidad_base
	jump_impulse_actual = jump_impulse

#Activar salto extra
func activar_salto_extra():
	jump_impulse_actual = jump_impulse * 2
	timer_power_up.start(5.0)


func _on_timer_power_up_2_timeout() -> void:
	jump_impulse_actual = jump_impulse
