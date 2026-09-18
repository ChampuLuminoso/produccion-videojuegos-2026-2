# Producción de Videojuegos - Sistemas Interactivos 2026
**Universidad Antonio Nariño (UAN)**  
**Facultad de Ingeniería de Sistemas y Computación**  

## 🏷️ Nombre del Proyecto
Sistema Interactivo Multi-Etapa — Proyecto Integrador (Laboratorios 1 a 4, Sprint 1)

## 📝 Descripción del Proyecto
Este repositorio aloja la línea base del proyecto integrador interactivo desarrollado durante el semestre académico 2026-2. Consiste en un sistema interactivo multi-etapa configurado bajo buenas prácticas de ingeniería de software en Godot Engine.

## 🎯 Objetivo del Software Interactivo
Construir, de forma incremental a lo largo del semestre, un sistema interactivo navegable con arquitectura profesional: pantallas modulares, comunicación desacoplada entre escenas mediante un Event Bus, componentes reutilizables y un historial de control de versiones documentado. Cada laboratorio agrega una capa de madurez arquitectónica sin romper el funcionamiento alcanzado en la entrega anterior.

## 📸 Captura de Pantalla del Estado Actual
> _Agrega aquí una captura del menú principal en ejecución (`F5` en Godot,
> luego `Alt+PrintScreen` o la herramienta de captura de tu sistema) y
> guárdala como `doc/screenshots/estado_actual.png`. Luego inserta:_
> `![Estado actual del proyecto](doc/screenshots/estado_actual.png)`

## 📂 Estructura de Directorios del Repositorio
El proyecto sigue una arquitectura modular con co-localización estricta
(cada escena vive junto a su script controlador, salvo Configuración y
Créditos, que desde el Lab 4 ya no requieren script propio):

```
src/
├── core/                       <- Lógica global del sistema
│   ├── event_bus.gd            <- Autoload "EventBus" (Observer/Singleton)
│   ├── global_manager.gd       <- Autoload "GlobalManager" (Lab 4)
│   ├── main_app.tscn           <- Escena principal (orquestador)
│   └── main_app.gd
├── scenes/
│   ├── main/                   <- Panel de menú principal
│   ├── simulation/             <- Panel de simulación (Paso 1)
│   ├── config/                 <- Panel de configuración (sin script)
│   └── credits/                <- Panel de créditos (sin script)
├── components/                 <- Nodos/micro-escenas reutilizables
│   └── navigation/
│       └── button_nav.tscn     <- Botón de navegación reutilizable (Lab 4)
└── assets/                     <- Recursos multimedia (audio, UI, texturas)
```

## 🧩 Arquitectura de Navegación Desacoplada
La navegación entre pantallas ya **no** usa llamadas directas y acopladas
(`get_tree().change_scene_to_file()`). En su lugar, se implementa un
**Event Bus global (Autoload `EventBus`)** que centraliza la comunicación
mediante el patrón Observer. Cada panel emite
`navigation_requested(target_scene, discard_previous)` y `MainApp` es el
único responsable de instanciar/liberar escenas de forma segura,
manteniendo además una pila `navigation_history` que registra la
secuencia de pantallas visitadas. El detalle de esta decisión está
documentado en
[`doc/adr/ADR-001-uso-de-event-bus.md`](doc/adr/ADR-001-uso-de-event-bus.md).

## 🧠 Estado Global Centralizado (GlobalManager)
Desde el Laboratorio 4, ningún panel calcula ni almacena datos de
negocio localmente. `GlobalManager` (Autoload) centraliza los precios y
la selección activa de la simulación en estructuras `Dictionary`,
escucha las señales `base_selected` e `item_added` del EventBus, y
notifica el resultado mediante `total_changed`. La interfaz
(`Step1Base`) solo emite intenciones y escucha ese resultado de forma
pasiva. Justificación completa en
[`doc/adr/ADR-003-global-manager-button-nav.md`](doc/adr/ADR-003-global-manager-button-nav.md).

## 🧩 Componentes Reutilizables
La lógica repetida entre paneles se extrae a `src/components/`. El
componente actual es `navigation/button_nav.tscn`: un `Button` con las
variables exportadas `target_scene` (selector de archivo `.tscn`) y
`discard_previous` (bandera para indicar si es un botón de "volver").
Se usa como instancia dentro de `menu_panel`, `config_panel`,
`credits_panel` y `step_1_base`, sin que esos paneles necesiten declarar
su propio callback de navegación. La justificación de la arquitectura
basada en escenas está documentada en
[`doc/adr/ADR-002-arquitectura-escenas.md`](doc/adr/ADR-002-arquitectura-escenas.md).

## 🎮 Mecánicas de Interacción (Lab 5)
La pantalla de simulación (`Step1Base`) responde a más de un tipo de
entrada: clic en los botones, y teclas numéricas (1, 2, 3) que disparan
exactamente los mismos callbacks, sin lógica duplicada. Además, cada
opción es una zona de interacción: al pasar el mouse sobre ella, un
`Label` indica cuál está activa bajo el cursor (`mouse_entered` /
`mouse_exited`).

## ⚙️ Tecnologías Utilizadas
* **Engine:** Godot Engine 4.x (Renderizador: *Compatibility* para portabilidad web)
* **Lenguaje:** GDScript 2.0 (Tipado estricto)
* **Versionamiento:** Git / GitHub para control de configuraciones
## 🎨 Personalización del Proyecto.

El nombre, la descripción y el ícono del proyecto se configuraron desde el panel interno de Godot Engine, siguiendo la ruta:

**Project > Project Settings > Application > Config**

Dentro de esa sección se editaron los siguientes campos:

* **Name:** Nombre visible del proyecto.
* **Description:** Breve descripción del propósito del sistema interactivo.
* **Icon:** Imagen personalizada (ubicada en `src/assets/ui/`)

## 👨‍💻 Autor
* **Nombre:** [Jorge Eliecer Montes Rodriguez]
* **Código Estudiantil:** [12242614169]
* **Programa:** Ingeniería de Software
