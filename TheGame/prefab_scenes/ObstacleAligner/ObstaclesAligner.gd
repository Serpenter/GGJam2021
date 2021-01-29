tool
extends Node2D


export(bool) var rerun = false setget process_children
export(String) var path_to_obstacle_parent = ""
export(String) var path_to_tilemap = ""

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func process_children(newVal):
    if Engine.editor_hint:

        if path_to_tilemap.empty():
            print("Set target tilemap path!")

        var tilemap = get_parent().get_node(path_to_tilemap)

        var align_root_node = self
        if not path_to_obstacle_parent.empty():
            align_root_node = get_parent().get_node(path_to_obstacle_parent)

        print("rearranging children...")

        for node in align_root_node.get_children():
            if node.get("is_alignable"):
                var tile = tilemap.world_to_map(node.position)
                node.position = tilemap.map_to_world(tile) + tilemap.cell_size/2
