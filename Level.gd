extends Spatial

var pieces = []
var tile_size = Vector3(2,2,2)
const board_size = Vector2(11,11)
const ray_length = 1000

var game_board = [[],[]]

# Called when the node enters the scene tree for the first time.
func _ready():
	#Load pieces
	for i in range (1,16):
		pieces.append(load("res://assets/Piece_id_" + str(i) + ".tscn"))
		
	
		#pieces[i-1].snapping = Vector3(1,1,1)
	var position = Vector3((randi() % 9)*2, 5, (randi() % 9) * 2)
	var new_shape = pieces[0].instance()#piece.instance()
	
	add_child(new_shape)
	var direction = Vector3.RIGHT
	new_shape.rotation.y = atan2(-direction.x, -direction.z)
	#tile_size = Vector2(
#		get_node("Cursor").texture.get_height(),
#		get_node("Cursor").texture.get_width()
#	)
	#tile_size = Vector2(get_node("Cursor").size.x,get_node("Cursor").size.y)
	#pieces[13]
	#for node in pieces[13].instance().get_children():
	#	for child in node.get_children():
	#		print(child.get_node("CollisionShape").shape.get_extents())
	
			#print(child.to_local(Vector3(1,1,1)))
			
	#		tile_size = child.get_scale()
	#tile_size = Vector3()
	
	#Scale Board
	#var board = get_node("Floor")
	#for child in board.get_children():
	#	child.set_scale(Vector3(2*board_size.x, 1, 2*board_size.y))
	#	child.transform.translate(Vector3(board_size.x,1,board_size.y))
		
	#Scale Cursor
	var cursor = get_node("Cursor")
	cursor.set_scale(Vector3(tile_size.x, tile_size.y, 1))
	
func spawn_shape_by_id(id, position):
	position = position.snapped(tile_size)
	var new_shape = pieces[id].instance()
	
	add_child(new_shape)
	for node in new_shape.get_children():
		for child in node.get_children():
			child.translate(position)
			
func rotateAround(obj, point, axis, angle):
	var rot = angle + obj.rotation.y 
	var tStart = point
	obj.global_translate (-tStart)
	obj.transform = obj.transform.rotated(axis, -rot)
	obj.global_translate (tStart)
	
func spawn_shape(position):
	randomize()
	position = position.snapped(tile_size)
	var new_shape = pieces[(randi() % len(pieces))].instance()#piece.instance()
	#print(pieces)
	#fnew_shape.
	for node in new_shape.get_children():
		for child in node.get_children():
			print(child.position.x, child.position.z)
	add_child(new_shape)
	new_shape.rotate_y(deg2rad(90.0))
	#rotateAround(new_shape, Vector3.ZERO, Vector3(0,1,0), deg2rad(90))
	#var current_rotation = new_shape.rotation
	#current_rotation.y += deg2rad(90)
	#new_shape.rotation = current_rotation
	for node in new_shape.get_children():
		#node.rotate(Vector3(0,0,90))
		for child in node.get_children():
			#var rounded_position = child.global_transform.origin.round_to_nearest(tile_size)
			#child.global_transform.origin = rounded_position
			child.translate(position)
			

func _input(event):
	if event is InputEventMouseButton:
		var cast = raycast_from_mouse(get_viewport().get_mouse_position(), 1)
		if cast.get("position"):
			#print(cast.position)
			#print(tile_size)
			#var tile_hovered = world_to_grid(cast.position)#Vector3(position.x / 2), 0, floor(cast.position.z / 2))
			#print("tile_hovered:",tile_hovered)
			#print(grid_to_world(Vector3(2 * tile_hovered.x, 5, 2 * tile_hovered.y)))
			#spawn_shape(grid_to_world(Vector3(2 * tile_hovered.x, 5, 2 * tile_hovered.z)))
			#print(Vector3(cast.position.x, 5, cast.position.z))
			#print(Vector3(cast.position.x, 5, cast.position.z).snapped(Vector3.ONE * tile_size))
			#print(world_to_grid(Vector3(cast.position.x, 5, cast.position.z)))
			#print("World:", grid_to_world(Vector3(cast.position.x, 5, cast.position.z).snapped(Vector3.ONE * tile_size)))
			spawn_shape(world_to_grid(grid_to_world(Vector3(cast.position.x, 5, cast.position.z).snapped(Vector3.ONE * tile_size))))
			#spawn_shape(Vector3(cast.position.x, 5, cast.position.z))
			
	if event is InputEventMouseMotion:
		var cast = raycast_from_mouse(get_viewport().get_mouse_position(), 1)
		if cast.get("position"):
			#print(cast.position)
			#print(tile_size)
			var tile_hovered = world_to_grid(cast.position)#Vector3(position.x / 2), 0, floor(cast.position.z / 2))
			#print(tile_hovered)
			
			var cursor = get_node("Cursor")
			
			cursor.translation = Vector3(cast.position.x, 1.5 ,cast.position.z)

	if event.is_action_pressed("ui_left"):
		randomize()
		var new_shape = pieces[(randi() % len(pieces))].instance()#piece.instance()
		#print(pieces)
		#fnew_shape.
		add_child(new_shape)
		
		var position = Vector3((randi() % 9)*2, 5, (randi() % 9) * 2)
		for node in new_shape.get_children():
			for child in node.get_children():
				child.translate(position)


func raycast_from_mouse(m_pos,collision_mask):
	var cam = get_node("Camera")
	var ray_start = cam.project_ray_origin(m_pos)
	var ray_end = ray_start + cam.project_ray_normal(m_pos) * ray_length
	var space_state = get_world().direct_space_state
	return space_state.intersect_ray(ray_start,ray_end, [], collision_mask)#["position"]

func world_to_grid(pos):
	var v = pos / tile_size
	return Vector3(floor(v.x), floor(v.y), floor(v.z))
	
func grid_to_world(pos):
	print("pos:", pos)
	var v = pos * tile_size
	print("v:", v)
	return v + tile_size #/ 2.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
