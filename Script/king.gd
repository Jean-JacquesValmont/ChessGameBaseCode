extends Sprite2D

var dragging = false
var clickRadius = 50
var dragOffset = Vector2()
var newPosition = Vector2(450, 750)
var moveCase = VariableGlobal.one_move_case
var chessBoard = [["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"],
["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"],
["x", "x", "rook_black", "knight_black", "bishop_black", "queen_black", "king_black", "bishop_black", "knight_black", "rook_black", "x", "x"],
["x", "x", "pawn_black", "pawn_black", "pawn_black", "pawn_black", "pawn_black", "pawn_black", "pawn_black", "pawn_black", "x", "x"],
["x", "x", "0", "0", "0", "0", "0", "0", "0", "0", "x", "x"],
["x", "x", "0", "0", "0", "0", "0", "0", "0", "0", "x", "x"],
["x", "x", "0", "0", "0", "0", "0", "0", "0", "0", "x", "x"],
["x", "x", "0", "0", "0", "0", "0", "0", "0", "0", "x", "x"],
["x", "x", "pawn_white", "pawn_white", "pawn_white", "pawn_white", "pawn_white", "pawn_white", "pawn_white", "pawn_white", "x", "x"],
["x", "x", "rook_white", "knight_white", "bishop_white", "queen_white", "king_white", "bishop_white", "knight_white", "rook_white", "x", "x"],
["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"],
["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"],]
var i = 9
var j = 6
@onready var name_of_piece = get_node(".").get_name()

func _ready():
	print(name_of_piece, " i: ", i, " j: ", j )

func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if (event.position - self.position).length() < clickRadius:
			# Start dragging if the click is on the sprite.
			if not dragging and event.pressed:
				dragging = true
				dragOffset = event.position - self.position
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			move(1,0)
			move(0,1)
			move(-1,0)
			move(0,-1)
			move(1,1)
			move(1,-1)
			move(-1,1)
			move(-1,-1)
			
			self.position = Vector2(newPosition.x, newPosition.y)
			dragging = false
		
#		for f in range(0,12):
#			if name_of_piece == "Bishop":
#				print(chessBoard[f])
		

	if event is InputEventMouseMotion and dragging:
		# While dragging, move the sprite with the mouse.
		self.position = event.position
		
		
func move(dx, dy) :
	for f in range (0,2):
		var targetCaseX = dx*(f*moveCase)
		var targetCaseY = dy*(f*moveCase)
		if global_position.x >= (newPosition.x - 50) + targetCaseX  and global_position.x <= (newPosition.x + 50) + targetCaseX \
		and global_position.y >= (newPosition.y - 50) + targetCaseY and global_position.y <= (newPosition.y + 50) + targetCaseY:
			self.position = Vector2((newPosition.x + targetCaseX), (newPosition.y + targetCaseY))
			newPosition = Vector2(self.position.x, self.position.y)
			chessBoard[i][j] = "0"
			i=i+(dy*f)
			j=j+(dx*f)
			chessBoard[i][j] = "king_white"
			break
		elif global_position.x >= get_parent().texture.get_width() or global_position.y >= get_parent().texture.get_height() :
			self.position = Vector2(newPosition.x, newPosition.y)
