extends CanvasLayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()


func toggle_pause():
	get_tree().paused = not get_tree().paused
	visible = get_tree().paused

	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_resume_pressed():
	toggle_pause()


func _on_quit_pressed():
	get_tree().quit()
