extends Sprite2D

var dragging = false
var clickRadius = 50
var dragOffset = Vector2()
var moveCase = VariableGlobal.one_move_case
var chessBoard = VariableGlobal.chessBoard
var i = 9
var j = 2
var Position = Vector2(50, 750)
@onready var nameOfPiece = get_name()
var initialPosition = true
var white = true
var textureBlack = preload("res://Sprite/Piece/Black/rook_black.png")
var maxMoveUp = 1
var maxMoveDown = 1
var maxMoveLeft = 1
var maxMoveRight = 1

func _ready():
	await get_tree().process_frame
	if self.position.y == 50 :
		white = false
		
	if white == true:
		set_name("RookWhite")
		nameOfPiece = get_name()
		if nameOfPiece == "RookWhite2":
			i = 9
			j = 9
			Position = Vector2(750,750)
	else:
		i = 2
		j = 2
		Position = Vector2(50, 50)
		texture = textureBlack
		set_name("RookBlack")
		nameOfPiece = get_name()
		if nameOfPiece == "RookBlack2":
			i = 2
			j = 9
			Position = Vector2(750,50)
		
	print(nameOfPiece, " i: ", i, " j: ", j, " new position: ", Position )

func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if (event.position - self.position).length() < clickRadius:
			# Start dragging if the click is on the sprite.
			if not dragging and event.pressed:
				dragging = true
				dragOffset = event.position - self.position
				z_index = 10
				maxMoveRight = checkMaxMove(1,0)
				maxMoveLeft = checkMaxMove(-1,0)
				maxMoveDown = checkMaxMove(0,1)
				maxMoveUp = checkMaxMove(0,-1)
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			if white == true and VariableGlobal.turnWhite == true:
				move(1,0, maxMoveRight)
				move(0,1, maxMoveDown)
				move(-1,0, maxMoveLeft)
				move(0,-1, maxMoveUp)
			elif white == false and VariableGlobal.turnWhite == false:
				move(1,0, maxMoveRight)
				move(0,1, maxMoveDown)
				move(-1,0, maxMoveLeft)
				move(0,-1, maxMoveUp)
			initialPosition = false
			self.position = Vector2(Position.x, Position.y)
			dragging = false
			z_index = 0
			for f in range(0,12):
				print(chessBoard[f])
				
	if event is InputEventMouseMotion and dragging:
		# While dragging, move the sprite with the mouse.
		self.position = event.position
		
func move(dx, dy, maxMove) :
#	A droite(1,0), En bas(0,1), A gauche(-1,0), En haut(0,-1)
	for f in range (1,maxMove):
		var targetCaseX = dx*(f*moveCase)
		var targetCaseY = dy*(f*moveCase)
		if global_position.x >= (Position.x - 50) + targetCaseX  and global_position.x <= (Position.x + 50) + targetCaseX \
		and global_position.y >= (Position.y - 50) + targetCaseY and global_position.y <= (Position.y + 50) + targetCaseY \
		and ((chessBoard[i+(dy*f)][j+(dx*f)] == "0" or "Black" in chessBoard[i+(dy*f)][j+(dx*f)]) and VariableGlobal.turnWhite == true\
		or (chessBoard[i+(dy*f)][j+(dx*f)] == "0" or "White" in chessBoard[i+(dy*f)][j+(dx*f)]) and VariableGlobal.turnWhite == false):
			self.position = Vector2((Position.x + targetCaseX), (Position.y + targetCaseY))
			Position = Vector2(self.position.x, self.position.y)
			chessBoard[i][j] = "0"
			i=i+(dy*f)
			j=j+(dx*f)
			chessBoard[i][j] = nameOfPiece.replace("@", "")
			VariableGlobal.turnWhite = !VariableGlobal.turnWhite
			print("TurnWhite dans move: ", VariableGlobal.turnWhite)
			break
		elif global_position.x >= get_parent().texture.get_width() or global_position.y >= get_parent().texture.get_height() :
			self.position = Vector2(Position.x, Position.y)
			
func _on_area_2d_area_entered(area):
	print("Collision effectué")
	var piece_name = area.get_parent().get_name()
	print("white: ", white)
	print("turnWhite: ", VariableGlobal.turnWhite)
	if white == true and VariableGlobal.turnWhite == false:
		if "Black" in piece_name and dragging == false :
			get_node("/root/ChessBoard/" + piece_name).queue_free()
	elif white == false and VariableGlobal.turnWhite == true:
		print("Prends la piece noir")
		if "White" in piece_name and dragging == false :
			get_node("/root/ChessBoard/" + piece_name).queue_free()
				
func checkMaxMove(dx, dy):
	for f in range (1,9):
		if chessBoard[i+(f*dy)][j+(f*dx)] != "0":
			if chessBoard[i+(f*dy)][j+(f*dx)] == "x":
				return f
			else:
				return f + 1
