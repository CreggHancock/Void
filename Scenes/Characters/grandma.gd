extends CharacterBody3D


const SPEED = 5.0

@export var state_timer_low : int = 1
@export var state_timer_high : int = 10
@export var detect_distance : int = 9
@export var cat : CharacterBody3D

enum State { IDLE, CHASING, WALKING }

var current_state = State.WALKING

func _read():
	randomize()

func _physics_process(delta):
	$RayCast3D.target_position = cat.global_position
	if current_state == State.CHASING:
		current_state = State.IDLE
		$StateTimer.start()
	var dist_to_cat = global_position.distance_squared_to(cat.global_position)
	if dist_to_cat < detect_distance && dist_to_cat > .08:
		if !$RayCast3D.is_colliding():
			current_state = State.CHASING
			look_at(cat.global_position)
			rotation.x = 0
			rotation.z = 0
			self.rotate_object_local(Vector3.UP, PI)
			$StateTimer.stop()
	
	
	if current_state == State.WALKING || current_state == State.CHASING:
		velocity = global_transform.basis * Vector3(0, 0, SPEED)
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
