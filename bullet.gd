extends Area3D

@export var speed: float = 15.0
@export var damage: int = 10

func _process(delta):
	translate(Vector3.FORWARD * speed * delta)

func _on_body_entered(body):
	if body.name == "Player3DTemplate":
		print("Jugador alcanzado por bala")
		var hud = get_tree().current_scene.get_node_or_null("HUD")
		if hud:
			hud.take_damage(damage)
	queue_free()
