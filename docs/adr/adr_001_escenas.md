# ADR 001: Adopción de una arquitectura basada en escenas modulares

## Estado
Aceptado

## Contexto
El proyecto inició en el Laboratorio 1 con dos escenas ubicadas
directamente en `src/scenes/` y su lógica en una carpeta plana
`src/scripts/`. A medida que el proyecto creció (Laboratorio 2), esa
organización mostró limitaciones:

- No existía una relación física clara entre una escena y su script:
  encontrar el controlador de una pantalla obligaba a buscar en una
  carpeta separada.
- No había un lugar definido para lógica verdaderamente global (como el
  futuro Event Bus) versus lógica específica de una pantalla.
- No existía ningún mecanismo para reutilizar un mismo fragmento de
  interfaz (por ejemplo, un botón de "volver") entre distintas escenas
  sin copiar y pegar su script.

Godot Engine está diseñado alrededor del concepto de **escena** como
unidad reutilizable de composición (un árbol de nodos que puede
instanciarse dentro de otro árbol). Ignorar ese modelo y tratar todo
como scripts sueltos desaprovecha la herramienta central del motor.

## Decisión
Se adopta una arquitectura basada en tres categorías de escenas, cada
una con una responsabilidad clara:

1. **`src/core/`** — Escenas y scripts de infraestructura global que no
   representan una pantalla visible para el usuario (`MainApp`,
   `EventBus`). Aquí vive la orquestación, no la interfaz.
2. **`src/scenes/<nombre>/`** — Una carpeta por cada pantalla completa
   de la aplicación (`menu`, `simulation`, `config`, `credits`),
   aplicando **co-localización estricta**: la escena `.tscn` y su script
   `.gd` viven en el mismo directorio.
3. **`src/components/<nombre>/`** — Escenas pequeñas y reutilizables que
   no representan una pantalla completa, sino un fragmento de interfaz
   que se instancia dentro de otras escenas (por ejemplo,
   `back_button/`, un botón que encapsula su propia lógica de
   navegación mediante una variable exportada).

Cada escena se trata como una unidad autocontenida: recibe su
configuración por variables `@export` (cuando aplica) y se comunica con
el resto del sistema únicamente a través del `EventBus`, nunca por
referencias directas a nodos de otras escenas.

## Consecuencias

### Positivas
- **Localización rápida**: cualquier persona nueva en el proyecto
  encuentra la escena y su lógica en la misma carpeta, sin tener que
  saltar entre directorios.
- **Reutilización real**: `back_button/` eliminó tres copias casi
  idénticas de la misma lógica (`config_panel`, `credits_panel`,
  `step_1_base`), reduciendo el código a mantener y el riesgo de que una
  copia se actualice y las otras no.
- **Escalabilidad**: agregar una nueva pantalla o un nuevo componente
  reutilizable sigue un patrón ya establecido, sin necesidad de rediseñar
  la organización del proyecto cada vez.
- **Consistencia con el motor**: se aprovecha el sistema nativo de
  escenas de Godot en vez de trabajar en contra de él con scripts
  sueltos.

### Negativas / Trade-offs
- **Más archivos y carpetas** que una estructura plana, lo que exige más
  disciplina al decidir dónde va cada cosa nueva (¿es una pantalla
  completa o un componente reutilizable?).
- **Curva de aprendizaje inicial** para quien no esté acostumbrado a
  pensar en términos de composición de escenas en vez de scripts
  independientes.
- Un componente mal diseñado (por ejemplo, con demasiadas
  responsabilidades) puede volverse tan complejo como el problema que
  buscaba resolver; se mitiga manteniendo cada componente enfocado en
  una sola responsabilidad (principio ya aplicado en `back_button/`, que
  solo sabe emitir una señal de navegación).
