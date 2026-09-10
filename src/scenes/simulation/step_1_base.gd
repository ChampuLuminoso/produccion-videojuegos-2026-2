# res://src/scenes/simulation/step_1_base.gd
extends Control

@onready var btn_ingrediente_1: Button = $GridContainer/BtnIngrediente1
@onready var btn_ingrediente_2: Button = $GridContainer/BtnIngrediente2
@onready var lbl_status_local: Label = $LblStatusLocal

func _ready() -> void:
	print("Panel de simulación (Paso 1) cargado de forma desacoplada.")

	btn_ingrediente_1.pressed.connect(_on_ingrediente_selected.bind("Base Tradicional", 1500))
	btn_ingrediente_2.pressed.connect(_on_ingrediente_selected.bind("Base Integral", 2000))
	# La navegación de vuelta al menú ahora la resuelve el componente
	# reutilizable BackButton (src/components/back_button/), instanciado
	# dentro de HBoxNavigation. Este script ya no gestiona ese botón.

func _on_ingrediente_selected(nombre_base: String, costo: int) -> void:
	lbl_status_local.text = "Selección local: %s (+$%d)" % [nombre_base, costo]
	# Notifica el cambio de parámetro a través del EventBus (Observer),
	# en lugar de que otras escenas dependan directamente de este nodo.
	EventBus.parameter_changed.emit(nombre_base, costo)
	print("Seleccionado de forma local: ", nombre_base)
