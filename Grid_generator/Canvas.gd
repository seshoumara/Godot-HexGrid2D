extends Control

var hex_grid: HexGrid2D

var hex_fill_color: Color
var hex_border_color: Color

func _draw() -> void:
	hex_grid.draw(self, hex_fill_color, hex_border_color)
