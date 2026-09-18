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

## Actividad 4 – Gestión de Estado Global, Componentes Reutilizables y Entrega Integradora (Sprint Review 1)

| Campo | Detalle |
|---|---|
| Fecha | 11/09/2026 |
| Funcionalidades implementadas | Se creó `GlobalManager` (Autoload) para centralizar el estado de la simulación (precios base, ítems adicionales y total) fuera de la GUI. Se actualizó `EventBus` con las señales `base_selected`, `item_added` y `total_changed`, y se amplió `navigation_requested` con el parámetro `discard_previous`. Se creó el componente reutilizable `ButtonNav` (reemplaza a `BackButton` del Lab 3), y `MainApp` ahora administra `navigation_history` con `.append()`/`.pop_back()`, imprimiendo su estado en consola tras cada navegación. `config_panel.gd` y `credits_panel.gd` se eliminaron por completo: su navegación se resuelve 100% desde el Inspector. `Step1Base` dejó de calcular el total localmente; ahora solo emite intenciones y escucha `total_changed` de forma pasiva. |
| Dificultades encontradas | Definir la semántica exacta de `discard_previous` en `navigation_history`: inicialmente se dudó si al "volver" también debía apilarse la ruta de destino además de hacer `pop_back()`. Se decidió que no, siguiendo la guía al pie de la letra, para que la pila represente fielmente el camino de avance del usuario sin duplicar entradas. También hubo que decidir cómo demostrar la señal `item_added` sin agregar una funcionalidad ajena al alcance del laboratorio; se resolvió con un único botón adicional de "extra" dentro de la misma pantalla de simulación ya existente. |
| Decisiones de diseño | Se consolidaron los tres ADR en una sola carpeta `doc/adr/` con nomenclatura unificada (`ADR-001`, `ADR-002`, `ADR-003`), corrigiendo la inconsistencia `doc/` vs `docs/` que había quedado entre el Lab 2 y el Lab 3. Se documentó en `ADR-003` la separación de responsabilidades entre `GlobalManager` (datos y cálculo) y las escenas (solo presentación), y la decisión de reemplazar `BackButton` por `ButtonNav` en vez de mantener ambos componentes. |
| Próximos pasos | Evaluar si `GlobalManager` necesita persistencia en disco (guardar/cargar configuración) en un laboratorio futuro. Agregar la captura de pantalla real al README. Considerar un componente reutilizable adicional para grupos de botones de selección (patrón `.bind()` repetido en `Step1Base`). |

## Actividad 5 – Interacción y Mecánicas Básicas

| Campo | Detalle |
|---|---|
| Actividad | Actividad 5 – Interacción y Mecánicas Básicas |
| Fecha | 18/09/2026 |
| Funcionalidades implementadas | Se agregó entrada por teclado en `Step1Base`: las teclas 1, 2 y 3 disparan las mismas acciones que los botones de selección de base y de extra, reutilizando exactamente los mismos callbacks (`_on_base_button_pressed`, `_on_item_button_pressed`) para no duplicar lógica. Se agregó una zona de interacción reactiva: al pasar el mouse sobre cada botón (`mouse_entered`/`mouse_exited`), un nuevo `Label` (`LblZonaActiva`) muestra cuál opción está bajo el cursor. |
| Dificultades encontradas | Decidir dónde conectar la entrada de teclado sin romper el patrón reactivo del Lab 4: se optó por `_unhandled_key_input()` en el propio `Step1Base`, mapeando teclas a los mismos callbacks que ya usaban los botones, en vez de crear una ruta paralela que duplicara la emisión de señales al EventBus. |
| Decisiones de diseño | La mecánica principal (seleccionar base/ítem) no cambió: se hizo accesible desde una segunda entrada (teclado) sin tocar `GlobalManager` ni el `EventBus`. La "zona de interacción" se implementó con las señales nativas `mouse_entered`/`mouse_exited` de Godot en vez de `Area2D`/colisiones, ya que el proyecto es una interfaz de `Control`, no un mundo físico — tal como la guía aclara que no todos los proyectos requieren colisiones. |
| Retroalimentación aplicada del Sprint anterior | Se mantuvo la disciplina de no duplicar callbacks (lección del Lab 3 y 4 con `ButtonNav`): la entrada de teclado reutiliza los mismos métodos que ya usaban los botones en vez de reescribir la lógica de selección. |
| Próximos pasos | Evaluar máquina de estados para la pantalla de simulación (mencionado como preparación para la siguiente actividad). Agregar retroalimentación sonora al seleccionar una opción. |
