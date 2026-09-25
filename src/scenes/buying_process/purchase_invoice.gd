# res://src/scenes/buying_process/purchase_invoice.gd
# ---------------------------------------------------------------------------
# Pantalla de resumen y confirmación de la compra. Lee el estado ya
# calculado en GlobalManager (nunca recalcula nada por su cuenta) y le
# pide a GlobalManager el mejor cupón disponible para el subtotal actual.
#
# NOTA DE ADAPTACIÓN: la guía de referencia usa nombres de ejemplo
# (selection["base"], item_1, item_2, prices[...]) pensados para un
# proyecto distinto con cantidades. Aquí se adaptó la misma lógica a los
# campos reales de este proyecto: GlobalManager.base_actual (String),
# GlobalManager.items_activos (Array[String]) y GlobalManager.total_actual.
# ---------------------------------------------------------------------------
extends Control

@onready var lbl_subtotal: Label = $VBoxContainer/LblSubtotal
@onready var lbl_coupon: Label = $VBoxContainer/LblCoupon
@onready var lbl_total: Label = $VBoxContainer/LblTotal
@onready var btn_confirm: Button = $VBoxContainer/BtnConfirm

var applied_coupon: Dictionary = {}

func _ready() -> void:
	btn_confirm.pressed.connect(_on_confirm)
	_update_invoice()

func _on_confirm() -> void:
	if not applied_coupon.is_empty():
		GlobalManager.remove_coupon(applied_coupon)
		applied_coupon = {}
	lbl_coupon.text = "Compra confirmada. ¡Gracias!"
	btn_confirm.disabled = true

func _update_invoice() -> void:
	var base_name: String = GlobalManager.base_actual
	var base_price: int = GlobalManager.precios_base.get(base_name, 0)

	var detalle_items: String = ""
	for item_id: String in GlobalManager.items_activos:
		var item_price: int = GlobalManager.precios_items.get(item_id, 0)
		detalle_items += "ITEM: %s    $%d\n" % [item_id, item_price]

	var subtotal: int = GlobalManager.total_actual

	lbl_subtotal.text = (
		"BASE ELEGIDA: %s    $%d\n"
		+ "%s"
		+ "--------------------------------\n"
		+ "Subtotal: $%d"
	) % [
		base_name if not base_name.is_empty() else "(ninguna)",
		base_price,
		detalle_items,
		subtotal,
	]

	# --- Regla de negocio: buscar y mostrar el mejor cupón aplicable ---
	applied_coupon = GlobalManager.get_best_coupon(subtotal)

	var discount: int = 0
	if not applied_coupon.is_empty():
		discount = applied_coupon["value"]

	var final_total: int = max(subtotal - discount, 0)

	if discount > 0:
		lbl_coupon.text = "Descuento aplicado por cupón: $%d" % discount
	else:
		lbl_coupon.text = "Sin cupón aplicable a esta compra."

	lbl_total.text = "TOTAL: $%d" % final_total
