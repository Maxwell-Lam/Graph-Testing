extends Node2D

var counter := 0; 
var size := 10; 

var previousNode = null;
var nextNode = null; 
var tailNode = null; 

var rootNode = null; 

var nodeCreationList = []

@onready var nodeSpawn = preload("res://node.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass; 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass; 

func _input(event: InputEvent) -> void: 	
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_C:
			clear_variables()
			make_grid(size); 
			var inputNode = find_node(nodeCreationList, 0, 0);
			rootNode = find_node(nodeCreationList, 0, 0)
			
			print(get_column_sum(size))
			print(get_row_sum(size))
			
			#connect_nodes(inputNode, null); 

func clear_variables():
	counter = 0; 
	nodeCreationList = []
	rootNode = null; 
	previousNode = null; 

func find_node(inputList, desiredX, desiredY):
	for eachNode in inputList: 
		if eachNode.xCord == desiredX and eachNode.yCord == desiredY:
			return eachNode; 

func make_grid(size: int) -> void:
	for i in size:
		for j in size: 
			var b = nodeSpawn.instantiate()
			counter += 1
			b.id = counter; 
			b.xCord = i; 
			b.yCord = j; 
			b.global_position = Vector2(i * 50, j * 50); 
			nodeCreationList.append(b)
			get_parent().add_child(b)
			
	var copyList = nodeCreationList.duplicate()
		
	for i in size:
		for j in size:
			var b = copyList.pop_front()
			if (b.xCord < size):
				b.eastNode = find_node(nodeCreationList, b.xCord + 1, b.yCord);
			if (b.yCord < size):
				b.southNode = find_node(nodeCreationList, b.xCord, b.yCord + 1);	
			if (b.xCord > 0):
				b.westNode = find_node(nodeCreationList, b.xCord - 1, b.yCord);	
			if (b.yCord > 0):
				b.northNode = find_node(nodeCreationList,b.xCord, b.yCord - 1);	

func get_column_sum(size: int) -> Array:
	var selectedNode = rootNode; 
	var selectedColumn = rootNode; 
	var columnSums = []
	for i in size: 
		var sum = 0; 
		for j in size: 
			sum = sum + selectedNode.id
			selectedNode = selectedNode.southNode
			 
		columnSums.append(sum)
		selectedColumn = selectedColumn.eastNode
		selectedNode = selectedColumn
		
	return(columnSums)

func get_row_sum(size:int) -> Array:
	var selectedNode = rootNode; 
	var selectedRow = rootNode; 
	var rowSums = []
	for i in size: 
		var sum = 0; 
		for j in size: 
			sum = sum + selectedNode.id
			selectedNode = selectedNode.eastNode
			 
		rowSums.append(sum)
		selectedRow = selectedRow.southNode
		selectedNode = selectedRow
		
	return(rowSums)

func connect_nodes(inputNode, inputPrevious):
	var notVisited = inputNode.visited_neighbors(); 

	if (notVisited.size() > 0):
		var selectedDirection = randi_range(0, notVisited.size() - 1)
		selectedDirection = notVisited[selectedDirection]
		var connectingNode = null; 
		
		if (selectedDirection == 1):
			connectingNode = inputNode.northNode; 
		if (selectedDirection == 2):
			connectingNode = inputNode.eastNode; 
		if (selectedDirection == 3):
			connectingNode = inputNode.southNode; 
		if (selectedDirection == 4):
			connectingNode = inputNode.westNode; 
			
		connectingNode.update_previous(inputNode)
		
		if (inputNode.visitedCreated == false):
			counter += 1; 
			inputNode.upgrade_text(counter); 
			inputNode.visitedCreated = true; 
			
		connect_nodes(connectingNode, inputNode)
	else:
		if (inputNode.visitedCreated == false):
			counter += 1; 
			inputNode.visitedCreated = true; 
			inputNode.upgrade_text(counter); 
			inputNode.update_previous(inputPrevious); 
		
		if (inputNode.id == 1):
			return true; 
		else:
			#connect_nodes(inputNode.previousNode, inputNode.previousNode.previousNode); 
			pass; 
			
