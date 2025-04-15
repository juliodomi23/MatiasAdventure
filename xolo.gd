extends CharacterBody2D

@export var follow_target : NodePath = "../Matías"
@export var max_distance : float = 40.0  # Distancia máxima permitida

var target : CharacterBody2D

func _ready():
	target = get_node(follow_target)
	# Colisión pequeña para evitar bloqueos
	$CollisionShape2D.shape.radius = 8.0  

func _physics_process(_delta):
	if !target: return
	
	# Solo animación (el movimiento lo controla el Joint)
	update_animation(target.velocity)

func update_animation(leader_velocity: Vector2):
	if leader_velocity.length() > 5.0:
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = leader_velocity.x < 0
	else:
		$AnimatedSprite2D.play("idle")
