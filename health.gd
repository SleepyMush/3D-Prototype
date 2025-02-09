class_name Health_Node
extends Node

@export var max_health : float
var health : float

func _ready() -> void:
	health = max_health

func damage_taken(value : float):
	health = clamp(health - value, 0 , max_health)
	if health > 0:
		print("taken ", value,  " damage ", health, " remaining.")
	else:
		#get_parent().visible = false
		print("die")

func heal(value : float):
	health = clamp(health + value, 0 , max_health)
