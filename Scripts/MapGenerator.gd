extends TileMap

const blocks = {
	"0": preload("res://Scenes/Fond.tscn"),
	"1": preload("res://Scenes/Boite.tscn")
}

func _process(delta):
	var parent = get_parent()
	for coord in get_used_cells():
		var celli = get_cell(coord.x,coord.y)
		var t = blocks[str(celli)].instance()
		t.position = coord * 32 + Vector2(16,16)
		parent.add_child(t)
	queue_free()
