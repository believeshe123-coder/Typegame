extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.003
const AIM_DISTANCE = 1000.0

var fireball_scene = preload("res://fireball.tscn")


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	if event is InputEventMouseMotion:
		# Look left and right
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)

		# Look up and down
		$CameraPivot.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)

		# Stop camera from flipping over
		$CameraPivot.rotation.x = clamp(
			$CameraPivot.rotation.x,
			deg_to_rad(-60),
			deg_to_rad(60)
		)


func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# WASD movement
	var input_dir = Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)

	var direction = (
		transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Shoot
	if Input.is_action_just_pressed("fire"):
		shoot_fireball()

	move_and_slide()


func shoot_fireball():
	var camera = $CameraPivot/Camera3D
	var crosshair = get_parent().get_node("HUD/Crosshair")

	# Find the actual center of the crosshair
	var crosshair_position = (
		crosshair.global_position
		+ crosshair.size / 2.0
	)

	# Cast an invisible ray from the camera through the crosshair
	var ray_origin = camera.project_ray_origin(crosshair_position)
	var ray_direction = camera.project_ray_normal(crosshair_position).normalized()
	var ray_end = ray_origin + ray_direction * AIM_DISTANCE

	var query = PhysicsRayQueryParameters3D.create(
		ray_origin,
		ray_end
	)

	# Don't aim at our own player collision
	query.exclude = [self]

	var result = get_world_3d().direct_space_state.intersect_ray(query)

	# If nothing is hit, aim far into the distance
	var target_position = ray_end

	# If the crosshair is over something, aim at that exact point
	if result:
		target_position = result.position

	# Create the fireball
	var fireball = fireball_scene.instantiate()
	get_parent().add_child(fireball)

	# Camera directions
	var forward = -camera.global_transform.basis.z.normalized()
	var camera_right = camera.global_transform.basis.x.normalized()

	# Fireball spawn location
	var spawn_distance = 1.0
	var spawn_right = 0.4
	var spawn_down = 0.3

	var spawn_position = (
		camera.global_position
		+ forward * spawn_distance
		+ camera_right * spawn_right
		+ Vector3.DOWN * spawn_down
	)

	fireball.global_position = spawn_position

	# Point fireball from its spawn location
	# toward whatever is underneath the crosshair
	fireball.look_at(target_position, Vector3.UP)
