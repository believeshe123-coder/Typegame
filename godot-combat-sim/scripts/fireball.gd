class_name Fireball
extends Area3D

@export var speed := 18.0
@export var damage := 20
@export var lifetime := 3.0

var _spent := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(lifetime).timeout.connect(queue_free)


func _physics_process(delta: float) -> void:
	global_position += -global_transform.basis.z * speed * delta


func _on_body_entered(body: Node3D) -> void:
	if _spent:
		return

	_spent = true
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
