extends Area2D
class_name GetElementBox

func _ready():
	connect("area_entered",absorb_element)

func absorb_element(body : ElementBox):
	if body == null : return
	var element_data : ElementData = body.get_element()
	if owner.has_method("get_element"):
		owner.get_element(element_data)
