extends TextureRect


export(int) var how_many
export(PackedScene) var item

export(Color, RGBA) var shade_color

signal selected(_packed_scene, _texture, _mod_color)

func _ready():
    var tmp_instance = item.instance()

    texture = tmp_instance.item_ui_texture
    rect_size = tmp_instance.item_ui_size
    self_modulate = tmp_instance.item_ui_color

    $Label.text = str(how_many)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass:

func _gui_input(event):
    if (event is InputEventMouseButton):
        if event.button_index == 1 and event.pressed and is_items_available():
            emit_signal("selected", item, self)


func on_item_picked():
    how_many -= 1
    $Label.text = str(how_many)
    if not is_items_available():
        modulate = shade_color

func is_items_available():
    return how_many > 0