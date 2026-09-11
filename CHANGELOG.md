# Changelog

Todos los cambios relevantes para el **producto** (no el proceso de
desarrollo — para eso está `DEVLOG.md`) se documentan en este archivo.

## [1.0.0] - Cierre Sprint 1 - 2026

### Added
- Proyecto inicial con entorno portátil de Godot 4 (Lab 1)
- Organización de carpetas bajo `src/` con convención snake_case (Lab 1)
- Escenas principales: menú e interacción local (Lab 1)
- Navegación básica entre dos pantallas (Lab 1)
- Event Bus global (Autoload) para navegación desacoplada (Lab 2)
- Panel de Configuración y Panel de Créditos (Lab 2)
- Componente reutilizable `BackButton` (Lab 3, reemplazado en Lab 4)
- Registro de Decisión Arquitectónica ADR-001, ADR-002 y ADR-003
- `GlobalManager` (Autoload) para el estado centralizado de la simulación (Lab 4)
- Componente reutilizable `ButtonNav` con pila de historial de navegación (Lab 4)
- Señales `base_selected`, `item_added` y `total_changed` en el EventBus (Lab 4)

### Changed
- Organización de la arquitectura del proyecto hacia escenas modulares (Lab 2)
- Separación de scripts y recursos por responsabilidad (Lab 2, Lab 3)
- Extracción de lógica de navegación duplicada a componentes reutilizables (Lab 3, Lab 4)
- `Step1Base` migrado de cálculo local de costos a reactividad pasiva vía EventBus (Lab 4)
- `menu_panel` reubicado de `src/scenes/menu/` a `src/scenes/main/` (Lab 4)
- Consolidación de los ADR en una única carpeta `doc/adr/` con nomenclatura unificada (Lab 4)
- `EventBus.navigation_requested` ampliada con el parámetro `discard_previous` (Lab 4)

### Removed
- Script huérfano `change_scene.gd` (Lab 2)
- Componente `back_button` (reemplazado por `button_nav`) (Lab 4)
- Scripts `config_panel.gd` y `credits_panel.gd` (navegación resuelta 100% declarativamente) (Lab 4)

### Fixed
- (Pendiente)
