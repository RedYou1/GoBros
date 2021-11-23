#Prends toutes les cellules et instancie un bloc avec son image à sa position.

extends TileMap

const block = preload("res://Scenes/Bloc.tscn")

#Les exceptions
const blocks = {
	"0": preload("res://Scenes/Fond.tscn"),
	"7": preload("res://Scenes/Lave.tscn"),
	"8": preload("res://Scenes/Eau.tscn"),
	"9": preload("res://Scenes/SansGravite.tscn")
}

func _process(delta):
	var parent = get_parent()
	for coord in get_used_cells():
		var celli = get_cell(coord.x,coord.y)
		var t
		if blocks.has(str(celli)):
			t = blocks[str(celli)].instance()
		else:
			t = block.instance()
			var sprite = t.get_node("Sprite")
			sprite.texture = tile_set.tile_get_texture(celli)
			sprite.region_enabled = true
			sprite.region_rect = tile_set.tile_get_region(celli)
		t.position = coord * 32 + Vector2(16,16)
		parent.add_child(t)
	queue_free()
