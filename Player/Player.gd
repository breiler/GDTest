extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 120
export var FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var sprite = $Sprite
onready var shadow = $Shadow

var state = MOVE
var velocity = Vector2.ZERO
var in_water = false


func _ready():
	animationTree.active = true

func _physics_process(delta):

	match state:
			MOVE:
				move_state(delta)
			
			ROLL:
				roll_state()
			
			ATTACK:
				attack_state()


func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		#animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("ui_accept"):
		state = ATTACK
	
func move():
	velocity = move_and_slide(velocity)
	
func roll_state():
	#velocity = roll_vector * ROLL_SPEED
	#animationState.travel("Roll")
	move()

func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
	
func attack_animation_finished():
	state = MOVE


func _on_GroundDetector_body_entered(body):
	if(body.is_in_group("water")):
		in_water = true
		shadow.visible = false
	


func _on_GroundDetector_body_exited(body):
	if(body.is_in_group("water")):
		in_water = false
		shadow.visible = true
	


func _on_Hurtbox_body_entered(body):
	print(body)
	pass # Replace with function body.


func _on_Hurtbox_body_exited(body):
	print(body)
	pass # Replace with function body.
