extends Area3D

const SPEED = 10.0
const DAMAGE = 20


func _ready():
	body_entered.connect(_on_body_entered)


func _physics_process(delta):
	global_position += -global_transform.basis.z * SPEED * delta


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(DAMAGE)

	queue_free()
