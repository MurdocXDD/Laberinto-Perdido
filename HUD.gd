extends CanvasLayer

@onready var coin_label = $CoinLabel
@onready var timer_label = $TimerLabel
@onready var health_bar = $HealthBar
@onready var damage_sound = $DamageSound # 👈 Agregamos referencia al sonido

var coins = 0
var time_elapsed = 0.0

# --- 🪙 MONEDAS ---
func update_coins(amount: int):
	coins += amount
	coin_label.text = "Monedas: " + str(coins)

func _on_coin_collected():
	update_coins(1)

# --- ⏱️ TIEMPO ---
func update_timer(delta: float):
	time_elapsed += delta
	timer_label.text = "Tiempo: " + str(snapped(time_elapsed, 0.1)) + " s"

# --- ❤️ VIDA ---
var max_health = 100
var current_health = 100

func _ready():
	update_health_bar()

func update_health_bar():
	health_bar.value = current_health

func take_damage(amount: int):
	current_health = max(current_health - amount, 0)
	update_health_bar()

	# --- 🔊 SONIDO DE DAÑO ---
	if damage_sound and not damage_sound.playing:
		damage_sound.play()

	if current_health <= 0:
		player_died()

func heal(amount: int):
	current_health = min(current_health + amount, max_health)
	update_health_bar()

# --- ☠️ MUERTE DEL JUGADOR ---
func player_died():
	print("¡El jugador ha muerto!")
	call_deferred("_go_to_game_over")

func _go_to_game_over():
	get_tree().change_scene_to_file("res://GameOver.tscn")
