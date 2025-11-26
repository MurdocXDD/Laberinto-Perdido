extends Node

var score = 0

func _on_coin_collected():
	score += 1
	print("Monedas: ", score)
