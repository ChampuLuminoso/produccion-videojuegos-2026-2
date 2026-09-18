# res://src/scenes/simulation/step_1_base.gd
# ---------------------------------------------------------------------------
# Actualizado en el Laboratorio 5: se agregan mecánicas de interacción
# básicas SOBRE la misma lógica reactiva del Lab 4 (nada de lo anterior
# se rompe ni se duplica):
#   1. Entrada de teclado: las teclas 1, 2 y 3 disparan las mismas
#      acciones que los botones (reutilizan los mismos callbacks).
#   2. Zona de interacción: al pasar el mouse sobre cada opción se
#      resalta cuál "zona" está activa en un Label dedicado.
# ---------------------------------------------------------------------------
extends Control

@onready var btn_ingrediente_1: Button = $GridContainer/BtnIngrediente1
@onready var btn_ingrediente_2: Button = $GridContainer/BtnIngrediente2
@onready var btn_extra: Button = $GridContainer/BtnExtra
@onready var lbl_status_local: Label = $LblStatusLocal
@onready var lbl_zona_activa: Label = $LblZonaActiva

func _ready() -> void:
	print("Panel de simulación (Paso 1) cargado de forma reactiva.")

	# --- Emisión de intenciones (este panel no sabe qué pasa después) ---
	btn_ingrediente_1.pressed.connect(_on_base_button_pressed.bind("Base Tradicional"))
	btn_ingrediente_2.pressed.connect(_on_base_button_pressed.bind("Base Integral"))
	btn_extra.pressed.connect(_on_item_button_pressed.bind("extra_queso"))

	# --- Zona de interacción: resalta qué opción está bajo el mouse ---
	btn_ingrediente_1.mouse_entered.connect(_on_zona_mouse_entered.bind("Base 1"))
	btn_ingrediente_2.mouse_entered.connect(_on_zona_mouse_entered.bind("Base 2"))
	btn_extra.mouse_entered.connect(_on_zona_mouse_entered.bind("Extra de Queso"))
	btn_ingrediente_1.mouse_exited.connect(_on_zona_mouse_exited)
	btn_ingrediente_2.mouse_exited.connect(_on_zona_mouse_exited)
	btn_extra.mouse_exited.connect(_on_zona_mouse_exited)

	# --- Escucha pasiva del resultado calculado por GlobalManager ---
	EventBus.total_changed.connect(_on_total_changed)

func _unhandled_key_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return

	# El teclado reutiliza EXACTAMENTE los mismos callbacks que los
	# botones: no hay ninguna lógica de selección duplicada.
	match event.keycode:
		KEY_1:
			_on_base_button_pressed("Base Tradicional")
		KEY_2:
			_on_base_button_pressed("Base Integral")
		KEY_3:
			_on_item_button_pressed("extra_queso")

func _on_base_button_pressed(base_name: String) -> void:
	EventBus.base_selected.emit(base_name)

func _on_item_button_pressed(item_id: String) -> void:
	EventBus.item_added.emit(item_id)

func _on_total_changed(new_total: int) -> void:
	lbl_status_local.text = "Total: $%d" % new_total

func _on_zona_mouse_entered(nombre_zona: String) -> void:
	lbl_zona_activa.text = "Zona activa: %s" % nombre_zona

func _on_zona_mouse_exited() -> void:
	lbl_zona_activa.text = "Zona activa: ninguna"
