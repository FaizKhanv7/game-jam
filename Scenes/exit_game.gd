extends Button

# Called when the node enters the scene tree
func _ready() -> void:
	# Connect the pressed signal to this function
	self.pressed.connect(_on_go_back_to_menu)

# Function called when the button is pressed
func _on_go_back_to_menu() -> void:
	get_tree().quit()
