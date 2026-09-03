# Producción de Videojuegos - Sistemas Interactivos 2026
**Universidad Antonio Nariño (UAN)**  
**Facultad de Ingeniería de Sistemas y Computación**  

## 📝 Descripción del Proyecto
Este repositorio aloja la línea base del proyecto integrador interactivo desarrollado durante el semestre académico 2026-2. Consiste en un sistema interactivo multi-etapa configurado bajo buenas prácticas de ingeniería de software en Godot Engine.

## 📂 Estructura de Directorios del Repositorio
A partir del Laboratorio 2, el proyecto sigue una arquitectura modular con
co-localización estricta (cada escena vive junto a su script controlador):

```
src/
├── core/                     <- Lógica global del sistema
│   ├── event_bus.gd          <- Autoload "EventBus" (Observer/Singleton)
│   ├── main_app.tscn         <- Escena principal (orquestador)
│   └── main_app.gd
├── scenes/
│   ├── menu/                 <- Panel de menú principal
│   ├── simulation/           <- Panel de simulación (Paso 1)
│   ├── config/                <- Panel de configuración
│   └── credits/               <- Panel de créditos
├── components/                <- Nodos/micro-escenas reutilizables
└── assets/                    <- Recursos multimedia (audio, UI, texturas)
```

## 🧩 Arquitectura de Navegación Desacoplada
La navegación entre pantallas ya **no** usa llamadas directas y acopladas
(`get_tree().change_scene_to_file()`). En su lugar, se implementa un
**Event Bus global (Autoload `EventBus`)** que centraliza la comunicación
mediante el patrón Observer. Cada panel emite `navigation_requested(ruta)`
y `MainApp` es el único responsable de instanciar/liberar escenas de forma
segura. El detalle de esta decisión está documentado en
[`doc/adr/0001-uso-de-event-bus.md`](doc/adr/0001-uso-de-event-bus.md).

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
