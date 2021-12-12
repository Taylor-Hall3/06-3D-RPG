extends KinematicBody

onready var Camera = $Pivot/Camera
onready var Pivot = $Pivot

var gravity = -30
var max_speed = 8
var mouse_sensitivity = 0.002
var mouse_range = 1.2
var target = null

var velocity = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("forward"):
		input_dir += -Camera.global_transform.basis.z
	if Input.is_action_pressed("back"):
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir += -Camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += Camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		Pivot.rotate_x(event.relative.y * mouse_sensitivity)
		Pivot.rotation_degrees.x = clamp(Pivot.rotation_degrees.x, -30, 15)

func _physics_process(delta):
	velocity.y += gravity * delta
	var desired_velocity = get_input() * max_speed
	
	$AnimationTree.set("parameters/Idle_Run/blend_amount", velocity/max_speed)
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
	if Input.is_action_just_pressed("shoot") and target != null and target.is_in_group("target"):
		target.queue_free()
