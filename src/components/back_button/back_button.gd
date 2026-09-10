# res://src/components/back_button/back_button.gd
# ---------------------------------------------------------------------------
# COMPONENTE REUTILIZABLE: BackButton
# ---------------------------------------------------------------------------
# Encapsula el patrón repetido en config_panel, credits_panel y
# step_1_base: un botón que emite "navigation_requested" hacia una ruta
# de escena fija. En vez de repetir @onready + connect + callback en cada
# panel, cualquier escena ahora puede instanciar back_button.tscn y solo
# configurar su ruta de destino desde el Inspector (@export).
# ---------------------------------------------------------------------------
extends Button
class_name BackButton

## Ruta de la escena a la que este botón debe navegar al ser presionado.
## Se configura desde el Inspector al instanciar el componente.
@export var target_scene_path: String = ""

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	if target_scene_path.is_empty():
		push_warning("BackButton: no se configuró 'target_scene_path' en el Inspector.")
		return
	EventBus.navigation_requested.emit(target_scene_path)
