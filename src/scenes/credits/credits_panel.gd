# res://src/scenes/credits/credits_panel.gd
extends Control

func _ready() -> void:
	print("Panel de créditos cargado de forma desacoplada.")
	# La navegación de vuelta al menú ahora la resuelve el componente
	# reutilizable BackButton (src/components/back_button/).
