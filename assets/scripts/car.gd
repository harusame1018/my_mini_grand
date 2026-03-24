extends VehicleBody3D


const MAX_STEER = 0.8
const ENGINE_POWER = 300
var can_move_car = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !Global.current_controller == "car": return
	if !can_move_car: return
	if Input.is_action_just_pressed("interact"):
		Global.current_controller = "player"
		$Camera3D.current = false
		get_node("/root/main/player/SpringArm3D/Camera3D").current = true
		get_node("/root/main/player").global_position = global_position + global_transform.basis.x * 1.5
		get_node("/root/main/player").show()
		get_node("/root/main/player/CollisionShape3D").disabled = false
		engine_force = 0
		steering = 0
		brake = 5
		can_move_car = false
		return
	steering = move_toward(steering,Input.get_axis("move_right","move_left") * MAX_STEER,delta * 2.5)
	engine_force = Input.get_axis("move_back","move_forward") * ENGINE_POWER
	print(steering)
func this_is_car():
	can_move_car = false
	await get_tree().create_timer(1).timeout
	can_move_car = true
