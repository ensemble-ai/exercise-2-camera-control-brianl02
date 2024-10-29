class_name AutoScroll
extends CameraControllerBase

@export var top_left:Vector2
@export var bottom_right:Vector2
@export var autoscroll_speed:Vector3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	position = target.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var travel_distance = delta * autoscroll_speed
	global_position.x += travel_distance.x
	global_position.y += travel_distance.y
	global_position.z += travel_distance.z
	
	var tpos = target.global_position
	var cpos = global_position
	
	#left
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - top_left.x)
	if diff_between_left_edges < 0:
		#move player as left edge pushes them
		#global_position.x += diff_between_left_edges
	#right
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + bottom_right.x)
	if diff_between_right_edges > 0:
		#negate players rightward movement so they do not leave the camera box
		#global_position.x += diff_between_right_edges
	#top
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - top_left.y)
	if diff_between_top_edges < 0:
		#negate players upward movement
		#global_position.z += diff_between_top_edges
	#bottom
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + top_left.y)
	if diff_between_bottom_edges > 0:
		#negate players downward movement
		#global_position.z += diff_between_bottom_edges
	
	
	super(delta)
		
func draw_logic() -> void:
	pass
