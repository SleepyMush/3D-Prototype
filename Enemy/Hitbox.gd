class_name hittable
extends Area3D

#Signal emit for the hitbox
signal damage_taken(damage_amount:float)

#Function to emit that signal
func hit(damage_amount : float):
	damage_taken.emit(damage_amount)
