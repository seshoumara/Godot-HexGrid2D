#todo: refactor this code!
class_name Voronoi

enum CELL_TYPE {RECT2, HEX2D}

var _grid: BaseGrid2D

var _points: Array = []
var _cluster_cells: Dictionary = {}
var _unmerged_cells: Array = []
var _clusters: Dictionary = {}

func generate_grid(cell_type: int, grid_orientation: int, grid_size: Vector2, cell_size: int) -> void:
	_points.clear()
	_cluster_cells.clear()
	_unmerged_cells.clear()
	_clusters.clear()
	var dummy_grid: BaseGrid2D
	if cell_type == CELL_TYPE.HEX2D:
		dummy_grid = HexGrid2D.new(grid_orientation, Vector2.ZERO, grid_size, cell_size, 1, 1)
		_grid = HexGrid2D.new(grid_orientation, Vector2.ZERO, grid_size, cell_size, dummy_grid.get_max_rows(), dummy_grid.get_max_columns())
	else:
		dummy_grid = RectGrid2D.new(grid_orientation, Vector2.ZERO, grid_size, cell_size, 1, 1)
		_grid = RectGrid2D.new(grid_orientation, Vector2.ZERO, grid_size, cell_size, dummy_grid.get_max_rows(), dummy_grid.get_max_columns())

func generate_points(total_points: int) -> void:
	if _grid == null:
		return
	_points.clear()
	for c in range(_grid.get_columns()):
		for r in range(_grid.get_rows()):
			_points.push_back(Vector2(c, r))
	_points.shuffle()
	_points.resize(total_points)

func generate_cluster_cells() -> void:
	if _grid == null:
		return
	_cluster_cells.clear()
	_unmerged_cells.clear()
	_clusters.clear()
	for point_idx in _points:
		_cluster_cells[point_idx] = []
	for c in range(_grid.get_columns()):
		for r in range(_grid.get_rows()):
			var cell = _grid.get_cell(r, c)
			var closest_point_idx: Vector2 = _points[0]
			var closest_distance: float = _grid.get_cell(0, 0).get_center().distance_squared_to(_grid.get_cell(_grid.get_rows() - 1, _grid.get_columns() - 1).get_center())
			for point_idx in _points:
				var distance = cell.get_center().distance_squared_to(_grid.get_cell(point_idx.y, point_idx.x).get_center())
				if distance < closest_distance:
					closest_distance = distance
					closest_point_idx = point_idx
			_cluster_cells[closest_point_idx].push_back(cell)

func generate_clusters() -> void:
	if _grid == null:
		return
	_unmerged_cells.clear()
	_clusters.clear()
	for point_idx in _cluster_cells.keys():
		var distance_sorter: BaseGrid2D.DistanceSorter = BaseGrid2D.DistanceSorter.new(_grid.get_cell(point_idx.y, point_idx.x))
		#Euclidian distance sorting might be the issue for lots of unmerged cells (especially hexes)
		_cluster_cells[point_idx].sort_custom(distance_sorter, "sort_by_Euclidean_distance_squared")
		var cluster: PoolVector2Array = _grid.get_cell_vertices(_cluster_cells[point_idx][0])
		var i: int = -1
		for cell in _cluster_cells[point_idx]:
			i += 1
			if i == 0:
				continue
			var polys: Array = Geometry.merge_polygons_2d(cluster, _grid.get_cell_vertices(cell))
			if polys.size() == 1:
				cluster = polys[0]
			else:
				_unmerged_cells.push_back(cell)
		_clusters[point_idx] = cluster
	fix_clusters()

#bug: merge of hex cells not working properly, even after fix_clusters()!!
func fix_clusters() -> void:
	if _grid == null:
		return
	var orphan_cells: Array = []
	for cell in _unmerged_cells:
		var merged: bool = false
		var cluster_idx: Vector2
		for point_idx in _clusters.keys():
			var polys: Array = Geometry.merge_polygons_2d(_clusters[point_idx], _grid.get_cell_vertices(cell))
			if polys.size() == 1:
				_clusters[point_idx] = polys[0]
				merged = true
				cluster_idx = point_idx
				break
		if merged:
			for point_idx in _cluster_cells.keys():
				if cell in _cluster_cells[point_idx]:
					_cluster_cells[point_idx].erase(cell)
					break
			_cluster_cells[cluster_idx].push_back(cell)
		else:
			orphan_cells.push_back(cell)
	print(_unmerged_cells.size(), " -> ", orphan_cells.size())
	_unmerged_cells.clear()

func draw_grid(canvas: CanvasItem) -> void:
	if _grid == null:
		return
	_grid.draw(canvas, Color8(255, 255, 255), Color8(0, 0, 0))

func draw_points(canvas: CanvasItem) -> void:
	if _grid == null:
		return
	for point_idx in _points:
		canvas.draw_circle(_grid.get_cell(point_idx.y, point_idx.x).get_center(), 2.5, Color8(255, 0, 0))

func draw_cluster_cells(canvas: CanvasItem) -> void:
	if _grid == null:
		return
	for point_idx in _cluster_cells.keys():
		var cluster_color: Color = Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1))
		for cell in _cluster_cells[point_idx]:
			canvas.draw_colored_polygon(_grid.get_cell_vertices(cell), cluster_color)

func draw_clusters(canvas: CanvasItem) -> void:
	if _grid == null:
		return
	for point_idx in _clusters.keys():
		var cluster_vertices: PoolVector2Array = _clusters[point_idx]
		cluster_vertices.push_back(_clusters[point_idx][0])
		canvas.draw_polyline(cluster_vertices, Color8(0, 0, 0), 2.0)
