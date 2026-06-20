extends Node3D
@onready var camera3d = $Camera3D
@onready var after_moved_point = $Marker3D
@onready var initial_point = $Marker3D2
@onready var scene2_1_point = $Marker3D3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_movie()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func play_movie():
	$Camera3D/horror.play()
	camera3d.global_position = initial_point.global_position
	camera3d.global_rotation.y = deg_to_rad(-133)
	var camera_tween = get_tree().create_tween()
	camera_tween.finished.connect(scene2)
	camera_tween.tween_property(camera3d,"global_position",after_moved_point.global_position,5)
	camera_tween.play()
	await get_tree().create_timer(4).timeout
	$Label.text = "さて、ゴミ場に箱庭を与えよう"
func scene2():
	$Label.text = ""
	await get_tree().create_timer(1).timeout
	camera3d.global_position = scene2_1_point.global_position
	camera3d.global_rotation.y = deg_to_rad(180)
	await get_tree().create_timer(2).timeout
	$CSGBox3D7/Label3D.show()
	await get_tree().create_timer(1).timeout
	$ColorRect.show()
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://assets/scenes/main.tscn")
