extends Node
@onready var points_label: Label = $"../UI/Panel/PointsLabel"
@onready var portal: Area2D = $"../SceneObjects/Finish" 

@export var hearts: Array[TextureRect]        # drag TextureRects here
const full_heart: Texture2D = preload("res://Assets/heart.png")
const half_heart: Texture2D = preload("res://Assets/halfheart.png")
const empty_heart: Texture2D = preload("res://Assets/emptyheart.png")           # assign image in Inspector

var points: int = 0
var lives: int = 10   # 10 = 5 full hearts

func decrease_health(amount: int = 1) -> void:
	lives = max(lives - amount, 0)
	_update_hearts()

	if lives == 0:
		get_tree().change_scene_to_file("res://main_menu.tscn")

func _update_hearts() -> void:
	var full_hearts: int = lives / 2   # integer division (no warning)
	var has_half: bool = (lives % 2) == 1

	for i in hearts.size():
		var heart_rect: TextureRect = hearts[i]

		if i < full_hearts:
			heart_rect.texture = full_heart
		elif i == full_hearts and has_half:
			heart_rect.texture = half_heart
		else:
			heart_rect.texture = empty_heart

func add_point() -> void:
	points += 1
	points_label.text = "Coins: " + str(points) + "/4"
	if points >= 4:
		portal.show()
