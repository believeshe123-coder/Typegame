extends StaticBody3D

var health = 100

func _ready():
	update_health_label()

func take_damage(amount):
	health -= amount
	update_health_label()

	if health <= 0:
		queue_free()

func update_health_label():
	$HealthLabel.text = str(health)
	
