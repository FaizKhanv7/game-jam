extends Control

@onready var main_buttons: VBoxContainer = $"Main Buttons"
@onready var options: Panel = $Options
	
	

	
func _ready():
	main_buttons.visible = true
	options.visible = false
	
func _on_start_pressed():
	Global.lives = 10
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")


func _on_settings_pressed():
	print("Settings Pressed")
	main_buttons.visible = false
	options. visible = true 


func _on_exit_pressed():
	print("Exit Pressedx")
	get_tree().quit()


func _on_back_options_pressed() -> void:
	_ready( 	)
