extends Control


export(Array, PackedScene) var items
var paked_selector_item = ResourceLoader.load("res://prefab_scenes/items/selector_item.tscn")
var child_width = 0


func _ready():
    pass
#    for item in items:
#        var _item = item.instance()
#        var sel_item = paked_selector_item.instance()
#
#        sel_item.rect_size = _item.item_size
#        sel_item.texture = _item.item_ui_texture
#        sel_item.self_modulate = _item.col
#        sel_item.rect_position.x += child_width
#
#        child_width += _item.item_size.x
#        #var tre = TextureRect.new()
#        $Viewport/Control.add_child(sel_item)
