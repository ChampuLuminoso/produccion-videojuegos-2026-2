# res://src/core/global_manager.gd
# ---------------------------------------------------------------------------
# GLOBAL MANAGER (Autoload / Singleton) — Laboratorio 4
# ---------------------------------------------------------------------------
# Único responsable de los datos y reglas de negocio de la simulación.
# No conoce ningún nodo de la GUI: solo escucha intenciones del usuario a
# través del EventBus ("el usuario eligió esta base", "el usuario agregó
# este ítem"), actualiza su propio estado interno, y notifica el
# resultado (el nuevo total) de vuelta al bus para que la interfaz
# reaccione de forma pasiva.
#
# Esto es lo que en el ADR-003 llamamos "separar el cerebro de la cara":
# GlobalManager es el cerebro (datos y cálculo), las escenas son la cara
# (solo muestran lo que el cerebro les dice).
# ---------------------------------------------------------------------------
extends Node

## Precios base disponibles en la simulación (mutuamente excluyentes:
## seleccionar una reemplaza a la anterior).
var precios_base: Dictionary = {
	"Base Tradicional": 1500,
	"Base Integral": 2000,
}

## Precios de ítems adicionales (acumulables).
var precios_items: Dictionary = {
	"extra_queso": 500,
}

## --- Estado actual de la simulación ---
var base_actual: String = ""
var items_activos: Array[String] = []
var total_actual: int = 0

## --- Cupones (Laboratorio 5) ---
## Ejemplo de estructura de un cupón:
## { "value": 2000, "minimum_purchase": 10000 }
## Los cupones se agregan aquí cuando el minijuego de gamificación
## emite EventBus.coupon_obtained — GlobalManager nunca conoce el
## minijuego, solo el resultado que publica.
var coupons: Array[Dictionary] = []

func _ready() -> void:
	EventBus.base_selected.connect(_on_base_selected)
	EventBus.item_added.connect(_on_item_added)
	EventBus.coupon_obtained.connect(_on_coupon_obtained)

func _on_base_selected(base_name: String) -> void:
	if not precios_base.has(base_name):
		push_warning("GlobalManager: base desconocida -> %s" % base_name)
		return
	base_actual = base_name
	_recalcular_total()

func _on_item_added(item_id: String) -> void:
	if not precios_items.has(item_id):
		push_warning("GlobalManager: ítem desconocido -> %s" % item_id)
		return
	if not items_activos.has(item_id):
		items_activos.append(item_id)
	_recalcular_total()

func _recalcular_total() -> void:
	var total: int = 0

	if precios_base.has(base_actual):
		total += precios_base[base_actual]

	for item_id: String in items_activos:
		if precios_items.has(item_id):
			total += precios_items[item_id]

	total_actual = total
	EventBus.total_changed.emit(total_actual)

## Reinicia el estado de la simulación (útil, por ejemplo, si en el
## futuro se agrega un botón de "reiniciar simulación").
func reiniciar() -> void:
	base_actual = ""
	items_activos.clear()
	total_actual = 0
	EventBus.total_changed.emit(total_actual)

# ---------------------------------------------------------------------------
# CUPONES (Laboratorio 5) — Reglas de negocio, separadas del cálculo del
# total: el "qué guardamos" (arriba) y el "qué hacemos con eso" (aquí)
# son responsabilidades distintas.
# ---------------------------------------------------------------------------

func _on_coupon_obtained(coupon: Dictionary) -> void:
	coupons.append(coupon)
	print("GlobalManager: cupón recibido -> ", coupon)

## Busca, entre los cupones disponibles, el de mayor valor que sí cumpla
## el monto mínimo de la compra actual. Devuelve un Dictionary vacío si
## ninguno aplica.
func get_best_coupon(subtotal: int) -> Dictionary:
	var best_coupon: Dictionary = {}

	for coupon: Dictionary in coupons:
		if subtotal >= coupon["minimum_purchase"]:
			if best_coupon.is_empty():
				best_coupon = coupon
			elif coupon["value"] > best_coupon["value"]:
				best_coupon = coupon

	return best_coupon

## Retira un cupón ya utilizado (se llama al confirmar la compra, nunca
## antes — mientras el usuario solo está revisando la factura, el cupón
## sigue disponible).
func remove_coupon(coupon: Dictionary) -> void:
	if coupon in coupons:
		coupons.erase(coupon)
