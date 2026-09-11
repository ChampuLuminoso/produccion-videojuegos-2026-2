# res://src/scenes/main/menu_panel.gd
extends Control

@onready var btn_salir: Button = $VBoxMenu/BtnSalir

func _ready() -> void:
	# La navegación hacia Simulación, Configuración y Créditos ahora la
	# resuelven las instancias de ButtonNav configuradas directamente en
	# la escena (ver menu_panel.tscn). Este script solo conserva la
	# acción local de cerrar la aplicación.
	btn_salir.pressed.connect(_on_btn_salir_pressed)

func _on_btn_salir_pressed() -> void:
	get_tree().quit()
