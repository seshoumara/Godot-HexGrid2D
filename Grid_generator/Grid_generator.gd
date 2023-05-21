extends Control

onready var Canvas_node: Control = $HBoxContainer/CenterContainer/Canvas

onready var Grid_height_node: HSlider = $HBoxContainer/MarginContainer/Settings/Setting_widgets/Grid_height
onready var Grid_width_node: HSlider = $HBoxContainer/MarginContainer/Settings/Setting_widgets/Grid_width
onready var Cell_size_node: HSlider = $HBoxContainer/MarginContainer/Settings/Setting_widgets/Cell_size
onready var Grid_orientation_node: OptionButton = $HBoxContainer/MarginContainer/Settings/Setting_widgets/CenterContainer1/Grid_orientation
onready var Rows_node: HSlider = $HBoxContainer/MarginContainer/Settings/Setting_widgets/Rows
onready var Columns_node: HSlider = $HBoxContainer/MarginContainer/Settings/Setting_widgets/Columns
onready var Fill_color_node: LineEdit = $HBoxContainer/MarginContainer/Settings/Setting_widgets/CenterContainer2/Fill_color
onready var Border_color_node: LineEdit = $HBoxContainer/MarginContainer/Settings/Setting_widgets/CenterContainer3/Border_color

onready var grid_size: Vector2 = Vector2(Grid_width_node.value, Grid_height_node.value)
onready var cell_size: int = Cell_size_node.value
onready var grid_orientation: int = Grid_orientation_node.get_item_id(Grid_orientation_node.selected)
onready var rows: int = Rows_node.value
onready var columns: int = Columns_node.value
onready var fill_color: Color = Color(Fill_color_node.text.to_lower())
onready var border_color: Color = Color(Border_color_node.text.to_lower())

func _ready() -> void:
	#VisualServer.set_default_clear_color(Color8(255, 255, 255))
	update_rc_sliders()
	generate()

func update_rc_sliders() -> void:
	var dummy_hex_grid: HexGrid2D = HexGrid2D.new(grid_orientation, Vector2.ZERO, grid_size, cell_size, 1, 1)
	Rows_node.max_value = dummy_hex_grid.get_max_rows()
	Rows_node.hint_tooltip = "1 -> " + String(Rows_node.max_value) + ", step 1"
	rows = int(Rows_node.value)
	Columns_node.max_value = dummy_hex_grid.get_max_columns()
	Columns_node.hint_tooltip = "1 -> " + String(Columns_node.max_value) + ", step 1"
	columns = int(Columns_node.value)

func _on_Grid_height_drag_ended(height_changed: bool) -> void:
	if height_changed:
		grid_size.y = Grid_height_node.value
		Canvas_node.rect_min_size = Vector2(Canvas_node.rect_min_size.x, grid_size.y)
		update_rc_sliders()
		generate()

func _on_Grid_width_drag_ended(width_changed: bool) -> void:
	if width_changed:
		grid_size.x = Grid_width_node.value
		Canvas_node.rect_min_size = Vector2(grid_size.x, Canvas_node.rect_min_size.y)
		update_rc_sliders()
		generate()

func _on_Cell_size_drag_ended(size_changed: bool) -> void:
	if size_changed:
		cell_size = int(Cell_size_node.value)
		update_rc_sliders()
		generate()

func _on_Grid_orientation_item_selected(index: int) -> void:
	grid_orientation = Grid_orientation_node.get_item_id(index)
	update_rc_sliders()
	generate()

func _on_Rows_drag_ended(rows_changed: bool) -> void:
	if rows_changed:
		rows = int(Rows_node.value)
		generate()

func _on_Columns_drag_ended(columns_changed: bool) -> void:
	if columns_changed:
		columns = int(Columns_node.value)
		generate()

func _on_Fill_color_text_changed(new_HTML_hex: String) -> void:
	fill_color = Color(new_HTML_hex.to_lower())
	generate()

func _on_Border_color_text_changed(new_HTML_hex: String) -> void:
	border_color = Color(new_HTML_hex.to_lower())
	generate()

func generate() -> void:
	Canvas_node.hex_grid = HexGrid2D.new(grid_orientation, Vector2.ZERO, grid_size, cell_size, rows, columns)
	Canvas_node.hex_fill_color = fill_color
	Canvas_node.hex_border_color = border_color
	Canvas_node.update()
