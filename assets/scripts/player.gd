extends CharacterBody3D

@onready var stamina_var = $Control/stamina/ProgressBar
@onready var camera = $SpringArm3D/Camera3D
@onready var interact_view = $Control/interact_view
var stamina = 100
var SPEED = 12.5
var is_dash = false
var is_heal_stamina = false
var is_near_car = false
var car_name = ""
var current_car = ""
var punch_is_colliding = false
var punch_colliding_body:Node3D = null
var is_attack = false
var can_talk_npc = false
var talk_npc = ""
var canmove = true
const JUMP_VELOCITY = 4.5
const dash_speed = 17.0
const normal_speed = 5.0

func _enter_tree() -> void:
	$"model/AnimationPlayer".play("walk")
	$"model/AnimationPlayer".stop()
	Global.current_controller = "player"

func _process(delta: float) -> void:
	if Global.current_controller == "car":
		for child in get_node("/root/main").get_children():
			if !child.name == current_car:
				continue
			global_position = child.global_position
func _physics_process(delta: float) -> void:
	if !Global.current_controller == "player": return
	if !canmove: return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += 6
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_just_pressed("reset_position"):
		global_position = Vector3(0,6.843,0)
	if Input.is_action_just_pressed("interact"):
		if is_near_car:
			Global.current_controller = "car"
			self.hide()
			for child in get_node("/root/main/cars").get_children():
				if !child.name == car_name:
					continue
				$SpringArm3D/Camera3D.current = false
				get_node("/root/main/cars/" + child.name + "/Camera3D").current = true
				child.this_is_car()
				current_car = car_name
				$CollisionShape3D.disabled = true
				is_near_car = false
				interact_view.hide()
		if can_talk_npc:
			for child in get_node("/root/main/npcs").get_children():
				if !child.name == talk_npc: continue
				canmove = false
				$Control/dialog.show()
				$Control/dialog/Label.text = child.line
				$Control/dialog/Label2.text = child.self_name
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				await $Control/dialog/Button.pressed
				$Control/dialog.hide()
				$Control/dialog/Label.text = ""
				$Control/dialog/Label2.text = ""
				canmove = true
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_pressed("punch") and not $model/AnimationPlayer.is_playing() and not is_attack:
		is_attack = true
		$model/AnimationPlayer.play("punch")
		if punch_is_colliding and punch_colliding_body.has_method("take_damage"):
			punch_colliding_body.take_damage($punch_pos)
		await $model/AnimationPlayer.animation_finished
		is_attack = false
	if Input.is_action_pressed("dash") and !is_heal_stamina:
		SPEED = dash_speed
		is_dash = true
	else:
		SPEED = normal_speed
		is_dash = false
	if is_dash and stamina > 0.5:
		stamina -= 0.5
		camera.fov = 90
	else:
		stamina += 0.25
		is_heal_stamina = true
		camera.fov = 75
	if stamina > 75:
		is_heal_stamina = false
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP,camera.global_rotation.y)
	if direction and not is_attack:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		$"model/AnimationPlayer".play("walk")
		var target_angle = atan2(direction.x, direction.z)
		$model.rotation.y = lerp_angle($model.rotation.y, target_angle, 0.15)
		$punch_area.rotation.y = lerp_angle($punch_area.rotation.y, target_angle, 0.15)
		$punch_pos.global_rotation.y = lerp_angle($punch_pos.rotation.y, target_angle, 0.15)
		$punch_pos.global_position = global_position + -$model.global_transform.basis.z * 2

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if $model/AnimationPlayer.current_animation == "walk":
			$"model/AnimationPlayer".stop()
	stamina_var.value = stamina
	move_and_slide()


func _on_car_interact_body_entered(body: Node3D) -> void:
	if !body.has_method("this_is_car"): return
	if !Global.current_controller == "player": return
	if body.is_object: return
	car_name = body.name
	is_near_car = true
	interact_view.show()


func _on_car_interact_body_exited(body: Node3D) -> void:
	if !body.has_method("this_is_car"): return
	is_near_car = false
	interact_view.hide()


func _on_punch_area_body_entered(body: Node3D) -> void:
	punch_is_colliding = true
	punch_colliding_body = body


func _on_punch_area_body_exited(body: Node3D) -> void:
	punch_is_colliding = false
	punch_colliding_body = null
