# res://src/scenes/gamification/falling_food.gd
# Un ingrediente que cae. Si el jugador lo recolecta (ver player.gd), se
# destruye desde ahí. Si en cambio toca el suelo sin ser recolectado, se
# destruye solo — así el jugador puede "perder" ingredientes.
extends RigidBody2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("floor"):
		queue_free()
