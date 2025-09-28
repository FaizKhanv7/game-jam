extends Area2D

@export var target_level : PackedScene

func _on_body_entered(body):
	if body.name == "Player":
		call_deferred("_change_scene")

func _change_scene():
	if (Global.lives < 10):
		Global.lives += 1
	get_tree().change_scene_to_packed(target_level)
