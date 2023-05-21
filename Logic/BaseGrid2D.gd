class_name BaseGrid2D

var _orientation: int
var _position: Vector2
var _size: Vector2
var _edge_size: int

var rows: int = 0 setget , get_rows
var max_rows: int = 0 setget , get_max_rows
var columns: int = 0 setget , get_columns
var max_columns: int = 0 setget , get_max_columns

var _grid: Array = [] #2d

func _init() -> void:
	#assert(false)
	pass

func get_cell(row: int, column: int):
	return _grid[row][column]

#workaround: Hex2D has this method, but Rect2 doesn't
func get_cell_vertices(cell) -> PoolVector2Array:
	var vertices: PoolVector2Array
	if typeof(cell) == TYPE_RECT2:
		vertices = PoolVector2Array([
			cell.position, cell.position + Vector2(cell.size.x, 0),
			cell.end, cell.position + Vector2(0, cell.size.y)
		])
	else:
		vertices = cell.get_vertices()
	return vertices

func get_rows() -> int:
	return rows

func get_max_rows() -> int:
	return max_rows

func get_columns() -> int:
	return columns

func get_max_columns() -> int:
	return max_columns

func draw(_canvas: CanvasItem, _fill_color: Color, _border_color: Color) -> void:
	pass

#todo: Manhattan distance
class DistanceSorter:
	var _reference_cell
	
	func _init(reference_cell) -> void:
		_reference_cell = reference_cell
	
	func sort_by_Euclidean_distance_squared(cell_a, cell_b) -> bool:
		var distance_a: float = cell_a.get_center().distance_squared_to(_reference_cell.get_center())
		var distance_b: float = cell_b.get_center().distance_squared_to(_reference_cell.get_center())
		return distance_a < distance_b
