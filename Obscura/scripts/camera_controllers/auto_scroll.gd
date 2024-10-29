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
	
	var tpos = target.global_position
	var cpos = global_position
	
	var travel_distance = delta * autoscroll_speed
	global_position.x += travel_distance.x
	global_position.y += travel_distance.y
	global_position.z += travel_distance.z
	
	#var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - box_width / 2.0)
	#if diff_between_left_edges < 0:
		#global_position.x += diff_between_left_edges
	##right
	#var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + box_width / 2.0)
	#if diff_between_right_edges > 0:
		#global_position.x += diff_between_right_edges
	##top
	#var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - box_height / 2.0)
	#if diff_between_top_edges < 0:
		#global_position.z += diff_between_top_edges
	##bottom
	#var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + box_height / 2.0)
	#if diff_between_bottom_edges > 0:
		#global_position.z += diff_between_bottom_edges
	
	
	super(delta)
		
func draw_logic() -> void:
	pass
