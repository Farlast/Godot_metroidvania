extends Resource
class_name HealthEvent

signal change(current : float, max : float)
signal add_max(amount : float)
signal subtract(amount : float)
