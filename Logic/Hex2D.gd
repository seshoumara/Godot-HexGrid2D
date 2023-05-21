class_name Hex2D

enum ORIENTATION {POINTY, FLAT}

var _orientation: int
var center: Vector2 setget , get_center
var _edge_size: int

var vertices: PoolVector2Array setget, get_vertices
var size: Vector2 setget , get_size
var clipped_size: Vector2 setget , get_clipped_size

func _init(orientation: int, hex_center: Vector2, edge_size: int) -> void:
	_orientation = orientation
	center = hex_center
	_edge_size = edge_size
	_construct_hex()
	_calculate_sizes()

func _generate_vertex(v: int) -> Vector2:
	var angle: float = (v * PI) / 3.0
	if _orientation == ORIENTATION.POINTY:
		angle -= PI / 6.0
	var x: float = center.x + (_edge_size * cos(angle))
	var y: float = center.y + (_edge_size * sin(angle))
	return Vector2(x, y)

func _construct_hex() -> void:
	for v in range(6):
		vertices.push_back(_generate_vertex(v))

func _calculate_sizes() -> void:
	var width: float = 2 * _edge_size
	var height: float = sqrt(3) * _edge_size
	size = Vector2(width, height)
	if _orientation == ORIENTATION.POINTY:
		size = Vector2(height, width)
	var clipped_width: float = 1.5 * _edge_size
	var clipped_height: float = 0.5 * sqrt(3) * _edge_size
	clipped_size = Vector2(clipped_width, clipped_height)
	if _orientation == ORIENTATION.POINTY:
		clipped_size = Vector2(clipped_height, clipped_width)

func get_center() -> Vector2:
	return center

func get_vertices() -> PoolVector2Array:
	return vertices

func get_size() -> Vector2:
	return size

func get_clipped_size() -> Vector2:
	return clipped_size

func draw(canvas: CanvasItem, fill_color: Color, border_color: Color) -> void:
	canvas.draw_colored_polygon(vertices, fill_color)
	var hex_vertices: PoolVector2Array = vertices
	hex_vertices.push_back(hex_vertices[0])
	canvas.draw_polyline(hex_vertices, border_color, 2)
