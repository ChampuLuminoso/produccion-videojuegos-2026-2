# res://src/scenes/simulation/step_1_base.gd
# ---------------------------------------------------------------------------
# Actualizado en el Laboratorio 4: este panel YA NO calcula ni guarda el
# costo localmente. Sus botones solo EMITEN intenciones al EventBus
# (mapeadas con .connect() + .bind() en _ready(), como exige la guía) y
# el Label escucha de forma pasiva la señal "total_changed" que emite
# GlobalManager tras recalcular. Step1Base no conoce a GlobalManager.
# ---------------------------------------------------------------------------
extends Control

@onready var btn_ingrediente_1: Button = $GridContainer/BtnIngrediente1
@onready var btn_ingrediente_2: Button = $GridContainer/BtnIngrediente2
@onready var btn_extra: Button = $GridContainer/BtnExtra
@onready var lbl_status_local: Label = $LblStatusLocal

func _ready() -> void:
	print("Panel de simulación (Paso 1) cargado de forma reactiva.")

	# --- Emisión de intenciones (este panel no sabe qué pasa después) ---
	btn_ingrediente_1.pressed.connect(_on_base_button_pressed.bind("Base Tradicional"))
	btn_ingrediente_2.pressed.connect(_on_base_button_pressed.bind("Base Integral"))
	btn_extra.pressed.connect(_on_item_button_pressed.bind("extra_queso"))

	# --- Escucha pasiva del resultado calculado por GlobalManager ---
	EventBus.total_changed.connect(_on_total_changed)

func _on_base_button_pressed(base_name: String) -> void:
	EventBus.base_selected.emit(base_name)

func _on_item_button_pressed(item_id: String) -> void:
	EventBus.item_added.emit(item_id)

func _on_total_changed(new_total: int) -> void:
	lbl_status_local.text = "Total: $%d" % new_total
