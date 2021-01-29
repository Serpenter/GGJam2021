extends RigidBody2D

var is_hovered = false
var is_active_mode = false

onready var face_normal_sprite = $FaceNormalSprite
onready var face_sad_sprite = $FaceSadSprite
onready var face_timer = $FaceTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_all_faces()
	set_face_color(Color.green)
	face_normal_sprite.visible = true


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
		
func disable_all_forcefield_passes():
	set_collision_mask_bit(3, true)
	set_collision_mask_bit(4, true)
	set_collision_mask_bit(5, true)
	set_face_color(Color.green)
		
func on_forcefield_panel_activation(forcefield_panel):
	disable_all_forcefield_passes()
	set_collision_mask_bit(forcefield_panel.forcefield_collision_layer, false)
	set_face_color(forcefield_panel.color)

func _on_InteractionArea_mouse_entered():
	is_hovered = true

func _on_InteractionArea_mouse_exited():
	is_hovered = false


func _on_Ball_body_entered(body):
	hide_all_faces()
	face_sad_sprite.visible = true
	face_timer.start()

func set_face_color(color):
	face_normal_sprite.modulate = color
	face_sad_sprite.modulate = color

func hide_all_faces():
	face_normal_sprite.visible = false
	face_sad_sprite.visible = false

func _on_FaceTimer_timeout():
	hide_all_faces()
	face_normal_sprite.visible = true
