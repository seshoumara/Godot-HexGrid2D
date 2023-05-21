extends Control

onready var Canvas_node: Control = $HBoxContainer/CenterContainer/Canvas
onready var Cell_type_node: OptionButton = $HBoxContainer/MarginContainer/Settings/Generate_grid_settings/CenterContainer/Cell_type
onready var Total_points_node: HSlider = $HBoxContainer/MarginContainer/Settings/Generate_points_settings/Total_points

#todo: Total_points_node's max_value is hardcoded, so 25 is the limit
#higher value means less cells which helps the hex merging much more
const cell_size: int = 20

onready var cell_type: int = Cell_type_node.get_item_id(Cell_type_node.selected)
onready var total_points: int = Total_points_node.value

func _ready() -> void:
	#VisualServer.set_default_clear_color(Color8(255, 255, 255))
	pass

func _on_Cell_type_item_selected(index: int) -> void:
	cell_type = Cell_type_node.get_item_id(index)

func _on_Generate_grid_pressed() -> void:
	var orientation: int = RectGrid2D.ORIENTATION.NORMAL
	if cell_type == Voronoi.CELL_TYPE.HEX2D:
		orientation = HexGrid2D.ORIENTATION.ODD_Q
	Canvas_node.generate_grid(cell_type, orientation, Canvas_node.rect_size, cell_size)

func _on_Total_points_drag_ended(points_changed: bool) -> void:
	if points_changed:
		total_points = int(Total_points_node.value)

func _on_Generate_points_pressed() -> void:
	Canvas_node.generate_points(total_points)

func _on_Generate_cluster_cells_pressed() -> void:
	Canvas_node.generate_cluster_cells()

func _on_Generate_clusters_pressed() -> void:
	Canvas_node.generate_clusters()
