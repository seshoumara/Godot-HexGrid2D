class_name RectGrid2D extends BaseGrid2D

enum ORIENTATION {NORMAL}

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

func _calculate_max_cr() -> void:
	var rect: Rect2 = Rect2(Vector2.ZERO, Vector2(_edge_size, _edge_size))
	max_rows = int(_size.y / rect.size.y)
	max_columns = int(_size.x / rect.size.x)

func _rect_coord_to_position(row: int, column: int) -> Vector2:
	var rect: Rect2 = Rect2(Vector2.ZERO, Vector2(_edge_size, _edge_size))
	var rect_position: Vector2 = Vector2(rect.size.x * column, rect.size.y * row)
	return rect_position + _position

func _generate_grid() -> void:
	for r in range(rows):
		_grid.push_back([])
		for c in range(columns):
			var rect_position: Vector2 = _rect_coord_to_position(r, c)
			var rect: Rect2 = Rect2(rect_position, Vector2(_edge_size, _edge_size))
			_grid[r].push_back(rect)

#func rect_to_vertices(rect: Rect2) -> PoolVector2Array:
#	return PoolVector2Array([
#		rect.position, rect.position + Vector2(rect.size.x, 0),
#		rect.end, rect.position + Vector2(0, rect.size.y)
#	])

func draw(canvas: CanvasItem, fill_color: Color, border_color: Color) -> void:
	if _grid.empty():
		return
	for r in range(rows):
		for c in range(columns):
			canvas.draw_rect(_grid[r][c], fill_color, true)
			var rect_vertices: PoolVector2Array = .get_cell_vertices(_grid[r][c])
			rect_vertices.push_back(rect_vertices[0])
			canvas.draw_polyline(rect_vertices, border_color, 2.0)
