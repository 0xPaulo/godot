# Estende as funcionalidades da classe CharacterBody3D para este script.
extends CharacterBody3D

var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.5
# const SENSIBILIDADE = 0.001
const SENSIBILIDADE = 0.005
const HIT_STAGGER = 2.0

#bob variaveis
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

# fov variaveis
# const BASE_FOV = 75.0
# const FOV_CHANGE =1.5

# signal
signal player_hit

# Obtém a gravidade das configurações do projeto para sincronização com os nós RigidBody.
var gravity = 9.8
var ataque_iniciado = false


@onready var head = $head
@onready var camera = $head/Camera3D
@onready var armaCamera = $head/Camera3D/arma/cruz_3d/SubViewportContainer/SubViewport/armaCamera
@onready var animacao_player = $AnimationPlayer
@onready var cruz_hitbox = $head/Camera3D/arma/cruz_3d/cruz_hitbox


func _process(_delta):
	armaCamera.global_transform = camera.global_transform
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
	if not animacao_player.is_playing() and Input.is_action_just_pressed("ataque"):
		animacao_player.play("ataque1")
		animacao_player.queue("volta-ataque1")
		ataque_iniciado = true

	# Se a animação atual for "ataque1", habilita a monitorização da hitbox
	elif animacao_player.current_animation == "ataque1" and ataque_iniciado:
			cruz_hitbox.monitoring = true
			ataque_iniciado = false  # Garante que o ataque só possa ser disparado uma vez até a animação de volta terminar

	# Se a animação atual for "volta-ataque1", desabilita a monitorização da hitbox
	elif animacao_player.current_animation == "volta-ataque1":
		cruz_hitbox.monitoring = false
			
			


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSIBILIDADE)
		camera.rotate_x(-event.relative.y * SENSIBILIDADE)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-48) , deg_to_rad(69))

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Aplica a gravidade somente se o personagem não estiver no chão.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Gerencia o salto.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Gerencia a corrida 
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed= WALK_SPEED

	# Obtém a direção do movimento e gerencia o movimento/desaceleração.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 15.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 15.0)
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)

	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)


	# Head bob
	t_bob += delta * velocity.length()* float(is_on_floor())
	camera.transform.origin =_headbob(t_bob) 

	# FOV
	# var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	# var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	# camera.fov = lerp(camera.fov , target_fov, delta * 8.0)


	move_and_slide()


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x =  cos(time * BOB_FREQ / 2 ) * BOB_AMP
	return pos


#func _on_animation_player_animation_finished(anim_name):
	#if anim_name == "ataque1":
		#cruz_hitbox.monitoring = false
		#animacao_player.play("RESET")


func _on_cruz_hitbox_area_entered(area):
	if area.is_in_group("inimigo"):
		print("hit")


func hit(dir):
	emit_signal("player_hit")
	velocity +=dir * HIT_STAGGER



func _on_cruz_hitbox_body_entered(body):
		if body.is_in_group("inimigo"):
			print("hit")
