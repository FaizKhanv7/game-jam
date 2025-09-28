extends CharacterBody2D

const SPEED = 450.0
const JUMP_VELOCITY = -750.0

const KNOCKBACK_X = 700.0
const KNOCKBACK_Y = -900.0
const KNOCKBACK_DURATION = 0.35
const KNOCKBACK_DECAY = 2000.0

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var attack_area = $AttackArea
@onready var game_manager: Node = get_node("/root/Main/GameManager")

var attacking: bool = false
var is_knocked: bool = false
var knockback_timer: float = 0.0

func hit_jump(direction: int) -> void:
	is_knocked = true
	knockback_timer = KNOCKBACK_DURATION
	velocity.x = direction * KNOCKBACK_X
	velocity.y = KNOCKBACK_Y
	sprite_2d.play("hurt")

func _ready():
	Global.spawn_position = global_position

func _input(event):
	if event.is_action_pressed("attack") and not attacking:
		perform_attack()

func _physics_process(delta: float) -> void:
	if is_knocked:
		knockback_timer -= delta
		velocity.x = move_toward(velocity.x, 0.0, KNOCKBACK_DECAY * delta)
		if knockback_timer <= 0.0 and is_on_floor():
			is_knocked = false
	else:
		if not attacking:
			if (abs(velocity.x) > 1.0) and is_on_floor():
				sprite_2d.play("running")
			elif not is_on_floor():
				sprite_2d.play("jumping")
			else:
				sprite_2d.play("default")

		if not is_on_floor():
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var direction_input := Input.get_axis("left", "right")
		if direction_input != 0.0:
			velocity.x = direction_input * SPEED
		else:
			velocity.x = 0.0   # <- no sliding

	if is_knocked and not is_on_floor():
		velocity += get_gravity() * delta

	sprite_2d.flip_h = velocity.x < 0.0

	move_and_slide()   # keep this for floor detection!


	
func play_hurt():
	sprite_2d.play("hurt")

@onready var attack_timer: Timer = $AttackTimer

func perform_attack():
	attacking = true 
	sprite_2d.play("attack") 
 
	#  Lose half a heart per attack
	game_manager.decrease_health(1)

	# Enable the hitbox for the duration of the attack
	attack_area.monitoring = true
	# Start the local timer instead of get_tree()
	attack_timer.start(0.3)
	await attack_timer.timeout
	
	await sprite_2d.animation_finished

	# Only continue if still alive (scene might have changed)
	if not is_inside_tree():
		return

	var overlapping_areas = attack_area.get_overlapping_areas()
	for area in overlapping_areas:
		var parent = area.get_parent()
		if parent.has_method("die"):
			parent.die()
		else:
			parent.queue_free()

	attack_area.monitoring = false
	attacking = false



	# Turn off hitbox
	attack_area.monitoring = false
	attacking = false
