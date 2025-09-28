extends Button

# Called when the node enters the scene tree
func _ready() -> void:
	# Connect the pressed signal to this function
	self.pressed.connect(_on_play_again_pressed)

# Function called when the button is pressed
func _on_play_again_pressed() -> void:
	Global.lives = 10
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")  # replace with your main scene path
