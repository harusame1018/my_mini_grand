extends SpringArm3D

@export var mouse_sens:float = 0.005
@export_range(-90,0.0,0.1,"radians_as_degrees") var min_vertical_angle: float = -PI/2
@export_range(0.9,90.0,0.1,"radians_as_degrees") var max_vertical_angle: float = PI/4
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !Global.current_controller == "player": return
	if Input.is_action_just_pressed("toggle_mouse_captured"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _unhandled_input(event: InputEvent) -> void:
	if !Global.current_controller == "player": return
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation.y -= event.relative.x * mouse_sens
		rotation.y = wrapf(rotation.y,0.0,TAU)
		rotation.x -= event.relative.y * mouse_sens
		rotation.x = clamp(rotation.x,min_vertical_angle,max_vertical_angle)
