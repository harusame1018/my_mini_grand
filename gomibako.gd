extends RigidBody3D

@export var bounce_force:float = 3.0
@export var bounce_up_ratio:float = 0.7
@export var cooldown_time: float = 0.3

var _can_bounce:bool = true

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if not _can_bounce:
		return
	for i in state.get_contact_count():
		var collider = state.get_contact_collider_object(i)
		if collider == null: continue
		if collider.is_in_group("stage"): continue
		var normal = state.get_contact_local_normal(i)
		normal.y += bounce_up_ratio
		normal = normal.normalized()
		apply_central_impulse(normal * bounce_force)
		_can_bounce = false
		get_tree().create_timer(cooldown_time).timeout.connect(func():_can_bounce = true)
		break
func take_damage(body):
	var direction = (global_position - body.global_position).normalized()
	direction.y = bounce_up_ratio
	direction = direction.normalized()
	apply_central_impulse(direction * bounce_force)
