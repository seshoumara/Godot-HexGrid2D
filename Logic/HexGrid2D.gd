class_name HexGrid2D extends BaseGrid2D

enum ORIENTATION {ODD_R, EVEN_R, ODD_Q, EVEN_Q}

var _grid_hex_orientation_map: Dictionary = {
	ORIENTATION.ODD_R: Hex2D.ORIENTATION.POINTY,
	ORIENTATION.EVEN_R: Hex2D.ORIENTATION.POINTY,
	ORIENTATION.ODD_Q: Hex2D.ORIENTATION.FLAT,
	ORIENTATION.EVEN_Q: Hex2D.ORIENTATION.FLAT
}

func _init(orientation: int, position: Vector2, size: Vector2, edge_size: int, grid_rows: int, grid_columns: int) -> void:
	if grid_rows <= 0 or grid_columns <= 0:
		return
	_orientation = orientation
	_size = size
	_edge_size = edge_size
	_calculate_max_cr()
	if grid_rows > max_rows or grid_columns > max_columns:
		return
	_position = position
	rows = grid_rows
	columns = grid_columns
	_generate_grid()

#todo: generalize
func _calculate_max_cr() -> void:
	var hex: Hex2D = Hex2D.new(_grid_hex_orientation_map[_orientation], Vector2.ZERO, _edge_size)
	if _orientation == ORIENTATION.ODD_Q or _orientation == ORIENTATION.EVEN_Q:
		max_rows = int((_size.y - hex.get_clipped_size().y) / hex.get_size().y)
		max_columns = int((_size.x - hex.get_size().x) / hex.get_clipped_size().x) + 1
	if _orientation == ORIENTATION.ODD_R or _orientation == ORIENTATION.EVEN_R:
		max_rows = int((_size.y - hex.get_size().y) / hex.get_clipped_size().y) + 1
		max_columns = int((_size.x - hex.get_clipped_size().x) / hex.get_size().x)

#todo: generalize
func _hex_coord_to_center(row: int, column: int) -> Vector2:
	var hex: Hex2D = Hex2D.new(_grid_hex_orientation_map[_orientation], Vector2.ZERO, _edge_size)
	var center: Vector2 = Vector2.ZERO
	if _orientation == ORIENTATION.ODD_Q or _orientation == ORIENTATION.EVEN_Q:
		center.x = (hex.get_clipped_size().x * column) + _edge_size
		center.y = hex.get_size().y * (row + 0.5)
		if column % 2 == (1 if _orientation == ORIENTATION.ODD_Q else 0):
			center.y += hex.get_clipped_size().y
	if _orientation == ORIENTATION.ODD_R or _orientation == ORIENTATION.EVEN_R:
		center.x = hex.get_size().x * (column + 0.5)
		if row % 2 == (1 if _orientation == ORIENTATION.ODD_R else 0):
			center.x += hex.get_clipped_size().x
		center.y = (hex.get_clipped_size().y * row) + _edge_size
	return center + _position

func _generate_grid() -> void:
	for r in range(rows):
		_grid.push_back([])
		for c in range(columns):
			var hex_center: Vector2 = _hex_coord_to_center(r, c)
			var hex: Hex2D = Hex2D.new(_grid_hex_orientation_map[_orientation], hex_center, _edge_size)
			_grid[r].push_back(hex)

func draw(canvas: CanvasItem, fill_color: Color, border_color: Color) -> void:
	if _grid.empty():
		return
	for r in range(rows):
		for c in range(columns):
			_grid[r][c].draw(canvas, fill_color, border_color)
