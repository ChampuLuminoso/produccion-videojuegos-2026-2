# res://src/scenes/config/config_panel.gd
extends Control

func _ready() -> void:
	print("Panel de configuración cargado de forma desacoplada.")
	# La navegación de vuelta al menú ahora la resuelve el componente
	# reutilizable BackButton (src/components/back_button/), configurado
	# desde el Inspector con su "target_scene_path". Este panel ya no
	# necesita conectar ni manejar ese botón manualmente.
