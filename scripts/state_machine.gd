extends Node
class_name StateMachine

@export var initial_state: NodePath
@onready var current_state: State = null

func _ready():
	print("Initializing StateMachine.")
	for state in get_children():
		if state is State:
			state.finished.connect(_on_state_finished)
			print("Connected signal for state:", state)

	if initial_state != null and has_node(initial_state):
		current_state = get_node(initial_state)
	else:
		current_state = get_child(0) 
		print("Defaulting to first state:", current_state)

	if current_state:
		current_state.enter("", {"player": owner})

func _process(delta):
	if owner.is_dying == true:
		return
		
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if owner.is_dying == true:
		return
	
	if current_state:
		current_state.physics_update(delta)

func _on_state_finished(next_state_path: String):
	print("Received signal to transition to state:", next_state_path)
	if not has_node(next_state_path):
		push_error("StateMachine: Target state '{}' not found.".format(next_state_path))
		return

	var previous_state_path = current_state.name
	
	current_state.exit()
	current_state = get_node(next_state_path)
	print("Transitioning to state:", next_state_path)
	current_state.enter(previous_state_path, {"player": owner})
