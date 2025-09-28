extends RigidBody2D
@onready var game_manager: Node = %GameManager


func _on_area_2d_body_entered(body):
	if (body.name == "Player"):
		var x_delta = body.position.x - position.x
		game_manager.decrease_health()
		body.play_hurt() # if you use this helper to play hurt animation
		var dir = 1 if x_delta > 0 else -1
		body.hit_jump(dir)

@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var is_dead: bool = false

func die():
	if is_dead:
		return
	is_dead = true
	var knockback_force = Vector2(200, -150)  # push left and slightly up
	if sprite_2d.flip_h:  # if sprite is facing left, flip direction
		knockback_force.x = 200
	linear_velocity = knockback_force
	
	sprite_2d.play("death")

	# Wait until death animation finishes before removing
	await sprite_2d.animation_finished
	queue_free()
