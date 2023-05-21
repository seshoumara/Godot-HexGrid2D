extends Control

var draw_grid: bool
var draw_cluster_cels: bool
var draw_clusters: bool
var draw_points: bool

var voronoi: Voronoi = Voronoi.new()

func generate_grid(cell_type: int, grid_orientation: int, grid_size: Vector2, cell_size: int) -> void:
	draw_grid = true
	draw_cluster_cels = false
	draw_clusters = false
	draw_points = false
	voronoi.generate_grid(cell_type, grid_orientation, grid_size, cell_size)
	update()

func generate_points(total_points: int) -> void:
	draw_grid = true
	draw_cluster_cels = false
	draw_clusters = false
	draw_points = true
	voronoi.generate_points(total_points)
	update()

func generate_cluster_cells() -> void:
	draw_grid = false
	draw_cluster_cels = true
	draw_clusters = false
	draw_points = true
	voronoi.generate_cluster_cells()
	update()

func generate_clusters() -> void:
	draw_grid = false
	draw_cluster_cels = false
	draw_clusters = true
	draw_points = true
	voronoi.generate_clusters()
	update()

func _draw() -> void:
	if draw_grid:
		voronoi.draw_grid(self)
	if draw_cluster_cels:
		voronoi.draw_cluster_cells(self)
	if draw_clusters:
		voronoi.draw_clusters(self)
	if draw_points:
		voronoi.draw_points(self)
