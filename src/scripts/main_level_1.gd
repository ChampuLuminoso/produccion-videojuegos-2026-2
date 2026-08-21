# res://main_level_1.gd
extends Control

@onready var btn_ingrediente_1: Button = $GridContainer/BtnIngrediente1
@onready var btn_ingrediente_2: Button = $GridContainer/BtnIngrediente2
@onready var lbl_status_local: Label = $LblStatusLocal

func _ready() -> void:
	# Conexiones locales del GridContainer
	btn_ingrediente_1.pressed.connect(_on_ingrediente_selected.bind("Base Tradicional", 1500))
	btn_ingrediente_2.pressed.connect(_on_ingrediente_selected.bind("Base Integral", 2000))

func _on_ingrediente_selected(nombre_base: String, costo: int) -> void:
	lbl_status_local.text = "Selección local: %s (+$%d)" % [nombre_base, costo]
	print("Seleccionado de forma local: ", nombre_base)
