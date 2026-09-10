# DEVLOG — Bitácora de Desarrollo

## [2026-08-21] - Configuración inicial e interacción local

**Autor:** Jorge Eliecer Montes Rodriguez

### Resumen
Se configuró el entorno de desarrollo con Godot Engine 4.7.1 (renderizador
Compatibility) y se estructuró el repositorio bajo la convención snake_case
dentro de la carpeta `src/`.

### Cambios realizados
- Creación de `main.tscn`: menú de inicio con `VBoxContainer` y botones
  `BtnSimular` / `BtnSalir`.
- Creación de `main_level_1.tscn`: pantalla de simulación con `GridContainer`
  y botones de selección de ingredientes.
- Implementación de `main.gd` y `main_level_1.gd` con tipado estático estricto,
  captura de nodos con `@onready`, y conexión de señales por código.
- Uso de `.bind()` para parametrizar dinámicamente el callback
  `_on_ingrediente_selected(nombre: String, costo: int)`.
- Configuración de navegación entre escenas mediante el nodo `SceneChanger`.
- Personalización de nombre, descripción e ícono del proyecto.

### Problemas encontrados y solución
- El script `main_level_1.gd` no quedó adjuntado al nodo raíz tras crearlo,
  por lo que los botones de ingredientes no reaccionaban. Se resolvió
  adjuntando el script existente al nodo `MainLevel1`.
- El botón `BtnVolver` quedó con dos conexiones de señal simultáneas
  (una hacia `SceneChanger` y otra dentro de `main_level_1.gd`), causando
  un error de referencia nula tras el cambio de escena. Se eliminó la
  conexión redundante dentro de `main_level_1.gd`.

### Próximos pasos
- Refactorizar la navegación para centralizarla completamente en `SceneChanger`.
- Preparar la grabación del video de sustentación.

## [2026-09-02] - Refactorización a Event Bus y navegación desacoplada

**Autor:** Jorge Eliecer Montes Rodriguez

### Resumen
Se refactorizó por completo la arquitectura plana del Laboratorio 1 hacia
un modelo modular con co-localización de escenas y scripts. Se eliminó la
dependencia directa a `get_tree().change_scene_to_file()` y se reemplazó
por un `EventBus` global (Autoload) que centraliza la comunicación entre
pantallas mediante el patrón Observer.

### Cambios realizados
- Creación de `src/core/event_bus.gd` registrado como Autoload `EventBus`,
  con las señales tipadas `navigation_requested` y `parameter_changed`.
- Creación de `src/core/main_app.gd` / `main_app.tscn` como orquestador
  central: se suscribe al bus, libera con `queue_free()` la escena previa
  y limpia la referencia (`current_scene = null`) antes de instanciar la
  siguiente, previniendo fugas de memoria.
- Reubicación y renombramiento de `main.tscn`/`main.gd` a
  `src/scenes/menu/menu_panel.tscn` / `.gd`, ahora con botones adicionales
  de Configuración y Créditos.
- Reubicación de `main_level_1.tscn`/`main_level_1.gd` a
  `src/scenes/simulation/step_1_base.tscn` / `.gd`.
- Creación de dos paneles nuevos: `src/scenes/config/config_panel.tscn` y
  `src/scenes/credits/credits_panel.tscn`, ambos co-localizados con su
  script y navegando exclusivamente vía `EventBus`.
- Eliminación del script huérfano `change_scene.gd` y de la carpeta vacía
  `src/scripts/`.
- Actualización de `project.godot`: nombre del proyecto a "Laboratorio 2",
  escena principal `src/core/main_app.tscn` y registro del Autoload.
- Redacción del ADR `doc/adr/0001-uso-de-event-bus.md` justificando la
  decisión arquitectónica.

### Problemas encontrados y solución
- Al desacoplar la navegación, inicialmente cada panel intentaba cargar
  directamente la siguiente escena, replicando el problema del Lab 1. Se
  corrigió delegando esa responsabilidad exclusivamente a `MainApp`,
  manteniendo a los paneles ciegos entre sí.
- Fue necesario decidir cómo tipar la señal `parameter_changed` dado que
  el valor puede ser de distinta naturaleza según el parámetro; se usó
  `Variant` de forma explícita para mantener tipado estricto sin perder
  flexibilidad.

### Próximos pasos
- Persistir el estado de selección de ingredientes entre paneles usando
  un recurso o Autoload de estado compartido.
- Añadir transiciones visuales (fade/tween) al cambiar de escena en
  `MainApp`.

## Actividad 3 – Arquitectura Profesional

| Campo | Detalle |
|---|---|
| Fecha | 10/09/2026 |
| Funcionalidades implementadas | No se agregaron funcionalidades nuevas (el alcance del Lab 3 es reorganizar, no extender). Se extrajo el componente reutilizable `src/components/back_button/`, encapsulando el patrón de navegación de retorno (`@export var target_scene_path` + emisión de `navigation_requested`) que antes estaba duplicado en `config_panel.gd`, `credits_panel.gd` y `step_1_base.gd`. Se crearon `CHANGELOG.md` y `docs/adr/adr_001_escenas.md`. |
| Dificultades encontradas | Detectar cuál lógica duplicada valía la pena extraer sin sobre-diseñar: se evaluó también extraer el patrón de selección con `.bind()` de los botones de ingrediente, pero se decidió no hacerlo porque cada callback tiene una firma y efecto distintos — no era duplicación real, solo un patrón similar. Solo se refactorizó lo que era código idéntico en más de un archivo. |
| Decisiones de diseño | Se organizó la carpeta `src/components/` (hasta ahora vacía desde el Lab 1) alrededor del principio de responsabilidad única: un componente reutilizable debe resolver un solo problema (en este caso, "volver a una escena fija") y configurarse por `@export` en vez de código repetido. Se documentó la justificación completa en `docs/adr/adr_001_escenas.md`. |
| Próximos pasos | Evaluar extraer un segundo componente reutilizable si aparece otro patrón duplicado (por ejemplo, un `OptionButtonGroup` genérico para grupos de selección con `.bind()`). Añadir captura de pantalla real al README. Continuar con la persistencia de estado entre escenas pendiente desde el Lab 2. |
