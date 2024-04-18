extends ProgressBar

@export var skill_status : CustomEventChannel
@onready var skill_icon : TextureRect = $TextureRect

func _ready():
	skill_status.float_event_sended.connect(set_value)
	skill_status.texture_event_sended.connect(set_icon)

func set_icon(icon:Texture2D):
	skill_icon.texture = icon
