extends OmniLight3D

@export var properties: Dictionary

func _ready():
	# split light color string into separate parts, then conver to number
	var components = properties["light_color"].split(" ")
	
	# apply values to node
	light_color = Color(float(components[0])/255, float(components[1])/255, float(components[2]/255))
	omni_range = properties["range"]
	shadow_enabled = true
	light_energy = properties["energy"]
