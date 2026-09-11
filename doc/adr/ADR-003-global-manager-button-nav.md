# ADR-003: Centralización del estado global (GlobalManager) y componente reutilizable de navegación (ButtonNav)

## Estado
Aceptado

## Contexto
Hasta el Laboratorio 3, el proyecto había resuelto correctamente el
desacoplamiento de la **navegación** (ADR-001) y la **organización física**
del código (ADR-002). Sin embargo, dos problemas seguían presentes:

1. **Estado de negocio disperso**: `step_1_base.gd` calculaba y
   almacenaba el costo total de la simulación directamente en una
   variable local, y lo escribía sobre un `Label` en la misma función que
   manejaba el clic del botón. Si en el futuro otra pantalla necesitara
   conocer ese total (por ejemplo, un panel de resumen o de checkout),
   no habría ninguna fuente de verdad centralizada a la cual consultar:
   solo una variable atrapada dentro de una escena que puede destruirse
   en cualquier momento con `queue_free()`.
2. **Navegación de "avance" y "regreso" sin distinción**: `BackButton`
   (Lab 3) resolvía bien la navegación hacia una ruta fija, pero no
   existía ningún mecanismo para que `MainApp` supiera si una navegación
   representaba entrar a una pantalla nueva o simplemente volver a la
   anterior, lo que impedía construir un historial de navegación
   confiable.

## Decisión

### 1. GlobalManager (Autoload)
Se crea `res://src/core/global_manager.gd`, registrado como Singleton
bajo el identificador `GlobalManager`. Centraliza:
- Los precios base y de ítems adicionales, en estructuras `Dictionary`.
- La selección activa del usuario (`base_actual`, `items_activos`).
- El cálculo del total (`_recalcular_total()`).

`GlobalManager` **no importa ni referencia ningún nodo de la GUI**. Solo
escucha las señales `base_selected` e `item_added` del `EventBus`, y
responde emitiendo `total_changed`. Cualquier pantalla que necesite
mostrar el total simplemente se suscribe a esa señal, sin acoplarse
nunca directamente a `GlobalManager` ni a `Step1Base`.

### 2. ButtonNav + navigation_history
Se reemplaza `BackButton` por `ButtonNav`
(`res://src/components/navigation/button_nav.tscn`), que agrega una
segunda propiedad exportada, `discard_previous: bool`. Al presionarse,
emite `navigation_requested(target_scene, discard_previous)`.

`MainApp` mantiene ahora `navigation_history: Array[String]`:
- `discard_previous = false` (navegación hacia adelante) → `.append()`
  de la ruta destino.
- `discard_previous = true` (botón de "volver") → `.pop_back()` antes de
  instanciar el panel.

Esto convierte a `MainApp` en el único punto del sistema que conoce la
secuencia de pantallas visitadas, sin que ninguna escena individual
necesite manejar esa lógica.

## Consecuencias

### Positivas
- **Una sola fuente de verdad**: el total de la simulación existe en un
  único lugar (`GlobalManager.total_actual`) que sobrevive
  independientemente de qué pantalla esté activa o se haya destruido.
- **Interfaces "tontas" y predecibles**: `Step1Base` no calcula nada; solo
  emite intenciones y refleja lo que el bus le informa. Esto reduce
  drásticamente la probabilidad de que el total mostrado en pantalla se
  desincronice del total real.
- **Eliminación de código duplicado**: `config_panel.gd` y
  `credits_panel.gd` se eliminaron por completo — su única
  responsabilidad (el botón de volver) ahora se configura de forma
  declarativa desde el Inspector con `ButtonNav`.
- **Trazabilidad de navegación**: `navigation_history` impreso en
  consola permite depurar visualmente el flujo de pantallas sin
  necesidad de un depurador gráfico.

### Negativas / Trade-offs
- **Un Autoload más en el proyecto**: `GlobalManager` se suma a
  `EventBus`, aumentando la superficie de "estado global" que debe
  usarse con disciplina para no convertirse en una bolsa de variables
  desordenadas a medida que crezca el proyecto.
- **Indirección adicional para depurar**: seguir el rastro completo de
  "¿por qué cambió el total?" ahora exige revisar tres archivos (el
  botón que emitió la señal, `GlobalManager` que la procesó, y el Label
  que escuchó el resultado) en vez de una sola función.
- **`ButtonNav` reemplaza a `BackButton`**: se eliminó el componente del
  Lab 3 para evitar mantener dos componentes con responsabilidades
  solapadas; cualquier proyecto que dependiera de `BackButton`
  necesitaría migrar a `ButtonNav`.
