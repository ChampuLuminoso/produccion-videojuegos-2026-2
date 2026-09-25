# ADR-004: Integración de Gamificación y Sistema de Recompensas Desacoplado

* **Estado:** Aprobado
* **Fecha:** 25/09/2026
* **Autor:** Jorge Eliecer Montes Rodríguez

## Contexto

El sistema existente utiliza un `EventBus` para desacoplar la comunicación
entre componentes y un `GlobalManager` para administrar el estado
compartido de la aplicación (ADR-001, ADR-003).

Se requiere incorporar una nueva mecánica interactiva de gamificación —un
minijuego de recolección con físicas 2D— capaz de generar recompensas
(cupones de descuento) para el proceso de compra.

Esta nueva funcionalidad debe permanecer independiente de las escenas
responsables de la compra, evitando establecer dependencias directas
entre el minijuego y la lógica existente.

## Decisión

Se implementa la mecánica de gamificación (`coupon_game.tscn`) como una
funcionalidad completamente independiente del proceso de compra
(`buying_process/`), viviendo en su propia carpeta `gamification/`.

El minijuego comunica la obtención de una recompensa mediante el Event
Bus, utilizando la señal `coupon_obtained(coupon: Dictionary)`. El
`GlobalManager` recibe esta información y administra los cupones
disponibles como parte del estado global (`coupons: Array[Dictionary]`).

La escena de factura (`purchase_invoice.tscn`) consulta al
`GlobalManager` mediante `get_best_coupon(subtotal)` para determinar el
mejor cupón válido según el subtotal, sin que el sistema de gamificación
necesite conocer ni modificar directamente la interfaz o la lógica de
compra.

### Nota de adaptación
El código de referencia de la guía asume un `GlobalManager` con campos
`selection["base"]`, `item_1`, `item_2` (cantidades) y `prices[...]`.
Este proyecto ya tenía, desde el Lab 4, una estructura distinta
(`base_actual: String`, `items_activos: Array[String]`,
`total_actual: int`). Se adaptó la lógica de la factura a esos campos
reales en vez de forzar un cambio de nomenclatura, para no reescribir
innecesariamente código ya probado del Sprint 1.

## Consecuencias

### Positivas
* La mecánica de gamificación permanece desacoplada del proceso de
  compra: ninguna escena de `buying_process/` referencia nodos de
  `gamification/`, ni viceversa.
* El minijuego puede reemplazarse por otra fuente de recompensas (por
  ejemplo, una ruleta) sin modificar la lógica de compra.
* Los cupones se administran desde un único punto del sistema
  (`GlobalManager`).
* La comunicación entre la gamificación y el resto del sistema utiliza
  exclusivamente el `EventBus`, manteniendo el mismo patrón Observer ya
  usado desde el Lab 2.
* La arquitectura permite incorporar nuevas mecánicas de recompensa sin
  crear dependencias directas entre escenas.

### Negativas / Costos
* El flujo de una recompensa requiere seguir la comunicación entre
  varios componentes (minijuego → EventBus → GlobalManager → factura),
  lo que añade indirección al depurar.
* `GlobalManager` incorpora una nueva responsabilidad (gestión de
  cupones) además del estado de la simulación de compra.
* El sistema debe controlar cuidadosamente las reglas de validación y
  consumo de cupones (monto mínimo, un solo cupón por compra, no
  permitir totales negativos) para evitar inconsistencias.
