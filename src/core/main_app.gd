# res://src/core/main_app.gd
# ---------------------------------------------------------------------------
# MAIN APP — Orquestador central de navegación (actualizado en el Lab 4)
# ---------------------------------------------------------------------------
# Además de instanciar/liberar escenas de forma segura (Lab 2), ahora
# también administra la pila de historial de navegación
# "navigation_history", genérica para todo el sistema: ninguna escena
# necesita saber que esta pila existe, solo emiten "navigation_requested"
# indicando si su navegación es un avance o un regreso.
# ---------------------------------------------------------------------------
extends Control

const MENU_SCENE_PATH: String = "res://src/scenes/main/menu_panel.tscn"

@onready var scene_container: Control = $SceneContainer

var current_scene: Node = null
var navigation_history: Array[String] = []

func _ready() -> void:
	EventBus.navigation_requested.connect(_on_navigation_requested)
	_on_navigation_requested(MENU_SCENE_PATH, false)

func _on_navigation_requested(target_scene: String, discard_previous: bool) -> void:
	# 1. Actualizar la pila de historial ANTES de instanciar el nuevo panel.
	if discard_previous:
		if not navigation_history.is_empty():
			navigation_history.pop_back()
	else:
		navigation_history.append(target_scene)

	print("MainApp: navigation_history -> ", navigation_history)

	# 2. Liberar de forma segura la escena activa previa (si existe).
	if current_scene:
		current_scene.queue_free()
		current_scene = null

	# 3. Cargar e instanciar la nueva escena solicitada.
	var new_scene_resource: PackedScene = load(target_scene) as PackedScene
	if new_scene_resource == null:
		push_error("MainApp: no fue posible cargar la escena: %s" % target_scene)
		return

	var new_scene_instance: Node = new_scene_resource.instantiate()
	scene_container.add_child(new_scene_instance)
	current_scene = new_scene_instance
