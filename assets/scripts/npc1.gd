extends Area3D

@export var self_name:String
@export var line:String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name = self_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if !body.is_in_group("players"): continue
		body.can_talk_npc = true
		body.talk_npc = name
	$Idle/AnimationPlayer.play("mixamo_com")

func _on_body_exited(body: Node3D) -> void:
	if !body.is_in_group("players"): return
	body.can_talk_npc = false
	body.talk_npc = ""
