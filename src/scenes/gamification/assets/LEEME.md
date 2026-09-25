# Assets pendientes (Kenney Physics Assets)

Descarga: https://kenney.nl/assets/physics-assets

Descomprime y copia estos archivos PNG a estas carpetas exactas:

- `aliens/alienGreen_suit.png` → jugador
- `aliens/alienBeige_round.png` → (opcional) representación visual del área de recolección
- `Other/starGold.png` → ingrediente que cae
- `Stone elements/elementStone016.png` → suelo
- `Stone elements/elementStone036.png` → paredes del embudo

Una vez copiados, en el editor de Godot reemplaza cada nodo `ColorRect`
llamado "Visual" por un `Sprite2D` apuntando a la imagen correspondiente
(o arrastra el PNG directamente sobre el ColorRect y cámbialo de tipo).
