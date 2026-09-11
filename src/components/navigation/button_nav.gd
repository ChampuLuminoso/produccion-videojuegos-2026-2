# res://src/components/navigation/button_nav.gd
# ---------------------------------------------------------------------------
# COMPONENTE REUTILIZABLE: ButtonNav — Laboratorio 4
# ---------------------------------------------------------------------------
# Reemplaza a BackButton (Lab 3). Además de emitir la solicitud de
# navegación, ahora informa si esta navegación debe "descartar" la
# entrada anterior del historial (discard_previous), lo que le permite a
# MainApp distinguir entre "ir hacia adelante" (apilar) y "volver"
# (desapilar), gestionando una pila de historial genérica sin que cada
# escena tenga que saber nada sobre esa pila.
# ---------------------------------------------------------------------------
extends Button
class_name ButtonNav

## Ruta de la escena destino. Se selecciona con el selector de archivos
## del Inspector gracias a @export_file, evitando errores de tipeo.
@export_file("*.tscn") var target_scene: String = ""

## true = este botón es un "regreso": MainApp hará pop_back() del
## historial en vez de apilar una nueva entrada.
@export var discard_previous: bool = false

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	if target_scene.is_empty():
		push_warning("ButtonNav: no se configuró 'target_scene' en el Inspector.")
		return
	EventBus.navigation_requested.emit(target_scene, discard_previous)
