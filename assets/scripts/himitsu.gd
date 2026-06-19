extends Area3D

@export var is_in_area:bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("players"):
		if is_in_area:
			body.is_himitsu_area = true
		else:
			body.out_himitsu_area = true
		print("うおおお、よく見つけたな")



func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("players"):
		if is_in_area:
			body.is_himitsu_area = false
		else:
			body.out_himitsu_area = true
