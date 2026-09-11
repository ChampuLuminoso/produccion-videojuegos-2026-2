# res://src/core/event_bus.gd
# ---------------------------------------------------------------------------
# EVENT BUS (Autoload / Singleton) — Actualizado en el Laboratorio 4
# ---------------------------------------------------------------------------
# Único canal de señales globales del Sprint 1. Ninguna escena conoce a
# otra directamente ni conoce a GlobalManager: todas se comunican a
# través de estas señales tipadas.
# ---------------------------------------------------------------------------
extends Node

## Navegación entre pantallas. "discard_previous" indica si esta
## navegación debe retirar la última entrada del historial (típico de un
## botón de "volver") en vez de apilar una nueva.
signal navigation_requested(target_scene: String, discard_previous: bool)

## El usuario seleccionó una base de simulación (reemplaza la selección anterior).
signal base_selected(base_name: String)

## El usuario agregó un ítem/accesorio adicional a la simulación.
signal item_added(item_id: String)

## GlobalManager recalculó el total y notifica el nuevo valor a la GUI.
signal total_changed(new_total: int)
