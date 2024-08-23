extends Node3D

@onready var hit_rect = $"SubViewportContainer/SubViewport/CanvasLayer/UI-DAMAGE-HIT"

# Called when the node enters the scene tree for the first time.
func _ready():
	hit_rect.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_boneco_player_hit():
	hit_rect.visible = true
	await  get_tree().create_timer(0.2).timeout
	hit_rect.visible = false
