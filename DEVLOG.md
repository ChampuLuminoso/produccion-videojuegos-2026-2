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
