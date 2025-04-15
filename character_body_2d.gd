extends CharacterBody2D

# Configuración
@export var walk_speed : float = 100
@export var run_speed : float = 200
@export var jump_height : float = 120 
@export var jump_duration : float = 0.5  

# Variables
var current_speed : float
var is_running : bool = false
var is_jumping : bool = false
var jump_progress : float = 0.0
var initial_y : float = 0.0

@onready var animated_sprite : AnimatedSprite2D = $Matias

func _ready():

	var joint = PinJoint2D.new()
	joint.name = "XoloAnchor"
	joint.node_a = self.get_path()  
	joint.node_b = "../Xolo"        
	joint.softness = 0.1           
	add_child(joint)
	current_speed = walk_speed
	initial_y = position.y

func _physics_process(delta):
	# 1. Manejar entrada
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# 2. Movimiento horizontal y vertical (si necesitas mover en 4 direcciones)
	velocity = input_dir * current_speed
	
	# 3. Correr (Shift)
	is_running = Input.is_action_pressed("run")
	current_speed = run_speed if is_running else walk_speed
	
	# 4. Salto (Espacio) - Solo si no estás saltando
	if Input.is_action_just_pressed("jump") and not is_jumping:
		start_jump()
	
	# 5. Actualizar salto (animación)
	if is_jumping:
		update_jump(delta)
	
	# 6. Animaciones
	update_animations(input_dir)
	
	move_and_slide()

func start_jump():
	is_jumping = true
	jump_progress = 0.0
	animated_sprite.play("Saltar")

func update_jump(delta):
	jump_progress += delta / jump_duration
	
	if jump_progress < 1.0:
		# Curva de salto suave (parábola)
		var t = jump_progress
		var jump_offset = jump_height * sin(t * PI)
		position.y = initial_y - jump_offset
	else:
		# Finalizar salto
		is_jumping = false
		position.y = initial_y

func update_animations(direction: Vector2):
	if is_jumping:
		return  # Mantener animación de salto
	
	if direction.length() > 0:
		animated_sprite.play("Caminar")
		animated_sprite.flip_h = direction.x < 0
		animated_sprite.speed_scale = 2.0 if is_running else 1.0
	else:
		animated_sprite.play("idle")
