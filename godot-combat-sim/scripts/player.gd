class_name CombatPlayer
extends CharacterBody3D

const SPEED := 5.0
const JUMP_VELOCITY := 4.5
const MOUSE_SENSITIVITY := 0.003
const AIM_DISTANCE := 1000.0

@export var fireball_scene: PackedScene = preload("res://fireball.tscn")
@export var spawn_distance := 1.0
@export var spawn_right := 0.4
@export var spawn_down := 0.3

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var crosshair: Control = get_parent().get_node("HUD/Crosshair")


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera_pivot.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera_pivot.rotation.x = clampf(
			camera_pivot.rotation.x,
			deg_to_rad(-60.0),
			deg_to_rad(60.0)
		)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)
	var direction := (
		transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)
	).normalized()

	if not direction.is_zero_approx():
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)
		velocity.z = move_toward(velocity.z, 0.0, SPEED)

	if Input.is_action_just_pressed("fire"):
		shoot_fireball()

	move_and_slide()


func shoot_fireball() -> void:
	if fireball_scene == null:
		push_warning("CombatPlayer cannot shoot without a fireball scene.")
		return

	var crosshair_position := crosshair.global_position + crosshair.size / 2.0
	var ray_origin := camera.project_ray_origin(crosshair_position)
	var ray_direction := camera.project_ray_normal(crosshair_position).normalized()
	var ray_end := ray_origin + ray_direction * AIM_DISTANCE
	var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.exclude = [get_rid()]

	var result := get_world_3d().direct_space_state.intersect_ray(query)
	var target_position := ray_end
	if not result.is_empty():
		target_position = result["position"]

	var fireball := fireball_scene.instantiate() as Node3D
	if fireball == null:
		push_error("The configured fireball scene must have a Node3D root.")
		return

	get_parent().add_child(fireball)
	var forward := -camera.global_transform.basis.z.normalized()
	var camera_right := camera.global_transform.basis.x.normalized()
	fireball.global_position = (
		camera.global_position
		+ forward * spawn_distance
		+ camera_right * spawn_right
		+ Vector3.DOWN * spawn_down
	)
	fireball.look_at(target_position, Vector3.UP)
