extends CharacterBody3D


const SPEED = 5.0

@export var state_timer_low : int = 1
@export var state_timer_high : int = 10
@export var cat : CharacterBody3D

enum State { IDLE, CHASING, WALKING }

var current_state = State.WALKING

func _read():
	randomize()

func _physics_process(delta):
	if current_state == State.WALKING:
		velocity = transform.basis * Vector3(0, 0, SPEED)
	else:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()


func _on_state_timer_timeout():
	rotation.y = randi() % 360
	$StateTimer.wait_time = min((randi() % state_timer_high) + state_timer_low, state_timer_high)
	if current_state == State.IDLE:
		current_state = State.WALKING
	elif current_state == State.WALKING:
		current_state = State.IDLE
	$StateTimer.start()
