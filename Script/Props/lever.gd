extends TriggerSwitch
class_name Lever

func take_damage(_damage_data:DamageData):
	switch_triggered.emit()
