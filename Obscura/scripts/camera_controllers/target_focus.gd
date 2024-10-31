class_name TargetFocus
extends CameraControllerBase

@export var lead_speed:float
@export var catchup_delay_duration:float
@export var catchup_speed:float
@export var leash_distance:float

@onready var time_passed:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	position = target.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#hi there - 10/31/24, 1:50am
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
		
	if just_switched:
		global_position.x = target.global_position.x
		global_position.z = target.global_position.z
		just_switched = false
		
		
	var tpos = target.global_position
	var cpos = global_position
	
	
	var distance = Vector2(tpos.x - cpos.x, tpos.z - cpos.z)
	var catchup_direction:Vector2 = distance.normalized()
	var input_direction = Vector2(target.velocity.normalized().x, 
									target.velocity.normalized().z)
	var movement = Vector2(0,0)
	
	if is_equal_approx(target.velocity.length(),0):
		if (time_passed < catchup_delay_duration):
			time_passed += delta
		elif (time_passed >= catchup_delay_duration):
			movement = catchup_direction * catchup_speed
			global_position.x += movement.x * delta
			global_position.z += movement.y * delta
		if round(distance.length()) == 0:
			global_position.x = target.global_position.x
			global_position.z = target.global_position.z
			time_passed = 0

	else:
		if target.velocity.length() > target.BASE_SPEED * 2:
			movement = input_direction * leash_distance
			global_position.x = tpos.x + movement.x
			global_position.z = tpos.z + movement.y
		else:
			if distance.length() < leash_distance:
				#if (!is_equal_approx(catchup_direction.x,-1*input_direction.x) || !is_equal_approx(catchup_direction.y,-1*input_direction.y)):
					#if (abs(abs(catchup_direction.x)-abs(input_direction.x)) <= 0.2) || (abs(abs(catchup_direction.y)-abs(input_direction.x)) <= 0.2) :
						#movement = input_direction * leash_distance
						#global_position.x = tpos.x + movement.x
						#global_position.z = tpos.z + movement.y
					#else:
						#movement = (catchup_direction + input_direction).normalized() * (lead_speed)
						#global_position.x += movement.x * delta
						#global_position.z += movement.y * delta
				#else:
				movement = input_direction * lead_speed
				global_position.x += movement.x * delta
				global_position.z += movement.y * delta
			elif distance.length() >= leash_distance:
				if (!is_equal_approx(catchup_direction.x,-1*input_direction.x) || !is_equal_approx(catchup_direction.y,-1*input_direction.y)):
					if (abs(abs(catchup_direction.x)-abs(input_direction.x)) <= 0.2) || (abs(abs(catchup_direction.y)-abs(input_direction.x)) <= 0.2) :
						movement = input_direction * leash_distance
						global_position.x = tpos.x + movement.x
						global_position.z = tpos.z + movement.y
					else:
						movement = (catchup_direction + input_direction).normalized() * (lead_speed)
						global_position.x += movement.x * delta
						global_position.z += movement.y * delta
				else:
					movement = input_direction * target.velocity.length()
					global_position.x += movement.x * delta
					global_position.z += movement.y * delta
				
		
	super(delta)
	
func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(0, 0, 5))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -5))
	
	immediate_mesh.surface_add_vertex(Vector3(5, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(-5, 0, 0))
	
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
