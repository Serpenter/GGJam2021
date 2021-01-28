extends RigidBody2D

var is_hovered = false
var is_active_mode = false

onready var face_normal_sprite = $FaceNormalSprite
onready var face_sad_sprite = $FaceSadSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	face_normal_sprite.visible = true
	face_sad_sprite.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_input()

func process_input():
	pass


func go_to_sleep_mode():
	sleeping = true

func go_to_actibe_mode():
	sleeping = false

func on_activation_zone_activated(activation_zone):
	if activation_zone.is_in_group("VictoryZone"):
#		go_to_sleep_mode()
		pass

func _on_InteractionArea_mouse_entered():
	is_hovered = true

func _on_InteractionArea_mouse_exited():
	is_hovered = false
