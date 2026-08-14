class_name TestDummy
extends StaticBody3D

signal health_changed(current: int, maximum: int)
signal defeated

@export var max_health := 100
@export var reset_delay := 1.5

var health: int
var _starting_transform: Transform3D
var _starting_collision_layer: int


func _ready() -> void:
	_starting_transform = global_transform
	_starting_collision_layer = collision_layer
	reset()


func take_damage(amount: int) -> void:
	if amount <= 0 or health <= 0:
		return

	health = maxi(health - amount, 0)
	health_changed.emit(health, max_health)
	if health == 0:
		defeated.emit()
		hide()
		collision_layer = 0
		get_tree().create_timer(reset_delay).timeout.connect(reset)


func reset() -> void:
	health = max_health
	global_transform = _starting_transform
	show()
	collision_layer = _starting_collision_layer
	health_changed.emit(health, max_health)
