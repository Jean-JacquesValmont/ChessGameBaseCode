extends Node

var chessBoard = []
var piece_white = [null,null,"RookWhite","KnightWhite","BishopWhite","QueenWhite","KingWhite","BishopWhite2","KnightWhite2","RookWhite2"]
var piece_black = [null,null,"RookBlack","KnightBlack","BishopBlack","QueenBlack","KingBlack","BishopBlack2","KnightBlack2","RookBlack2"]
var attack_piece_white_on_the_chessboard = []
var attack_piece_black_on_the_chessboard = []

var one_move_case = 100
var turnWhite = true
var update_of_the_parts_attack = false
var directionOfAttack = "Aucune"
var attackerPositioni
var attackerPositionj
var checkWhite = false
var checkBlack = false
var pieceProtectTheKing = false

func _ready():
	createBoard(12,12)
	initialisingChessBoard()
	createAttackBoardWhiteAndBlack(12,12)
	initialisingAttackBoardWhiteAndBlack()

func _process(delta):
	await get_tree().process_frame
	if turnWhite == true:
#		get_node("/root/ChessBoard/Camera2D").set_rotation_degrees(0)
		if update_of_the_parts_attack == false:
			updateAttackWhiteandBlack()
			attackPiecesWhite()
			attackPiecesBlack()
			verificationCheckAndCheckmate()
			update_of_the_parts_attack = true
			
	elif turnWhite == false:
#		get_node("/root/ChessBoard/Camera2D").set_rotation_degrees(180)
		if update_of_the_parts_attack == true:
			updateAttackWhiteandBlack()
			attackPiecesWhite()
			attackPiecesBlack()
			verificationCheckAndCheckmate()
			update_of_the_parts_attack = false

func createBoard(rowSize,columnSize):
	for i in range(rowSize):
		var row = []
		for j in range(columnSize):
			row.append(null)
		chessBoard.append(row)
	#	print(chessBoard)
	#	print("ChessBoard created. Size: ", rowSize, "x", columnSize)

func initialisingChessBoard():
	for i in range(2,3):
		for j in range(2,10):
			chessBoard[i][j] = piece_black[j]
	for j in range(3, 10):
		chessBoard[3][2] = "PawnBlack"
		chessBoard[3][j] = "PawnBlack" + str(j-1)
	for i in range(4,8): 
		for j in range(2,10):
			chessBoard[i][j] = "0"
	for j in range(3, 10):
		chessBoard[8][2] = "PawnWhite"
		chessBoard[8][j] = "PawnWhite" + str(j-1)
	for i in range(9,10): 
		for j in range(2,10):
			chessBoard[i][j] = piece_white[j]
	for i in range(0,12):
		for j in range(0,12):
			if chessBoard[i][j] ==  null:
				chessBoard[i][j] = "x"
	
	print("ChessBoard: ")
	for i in range(0,12):
		print(chessBoard[i])

func createAttackBoardWhiteAndBlack(rowSize,columnSize):
	for i in range(rowSize):
		var row = []
		for j in range(columnSize):
			row.append(null)
		attack_piece_white_on_the_chessboard.append(row)
		
	for i in range(rowSize):
		var row = []
		for j in range(columnSize):
			row.append(null)
		attack_piece_black_on_the_chessboard.append(row)
	#	print(attack_piece_white_on_the_chessboard)
	#	print(attack_piece_black_on_the_chessboard)

func initialisingAttackBoardWhiteAndBlack():
	for i in range(2,10): 
		for j in range(2,10):
			attack_piece_white_on_the_chessboard[i][j] = 0
			attack_piece_black_on_the_chessboard[i][j] = 0

	for i in range(0,12):
		for j in range(0,12):
			if attack_piece_white_on_the_chessboard[i][j] ==  null:
				attack_piece_white_on_the_chessboard[i][j] = -9
	
	for i in range(0,12):
		for j in range(0,12):
			if attack_piece_black_on_the_chessboard[i][j] ==  null:
				attack_piece_black_on_the_chessboard[i][j] = -9
	
	printAttackWhite()
	printAttackBlack()

func updateAttackWhiteandBlack():
	for i in range(2,10): 
		for j in range(2,10):
			attack_piece_white_on_the_chessboard[i][j] = 0
	for i in range(2,10): 
		for j in range(2,10):
			attack_piece_black_on_the_chessboard[i][j] = 0

func printAttackWhite():
	print("AttackBoardWhite: /AttackBoardBlack: ")
	for i in range(0,12):
		print(attack_piece_white_on_the_chessboard[i],attack_piece_black_on_the_chessboard[i])

func printAttackBlack():
	print("AttackBoardBlack: /AttackBoardWhite: ")
	for i in range(0,12):
		print(attack_piece_black_on_the_chessboard[i],attack_piece_white_on_the_chessboard[i])

func pawnAttackWhite(i, j, chessBoard, attack_piece_white_on_the_chessboard):
	for dx in [-1, 1]:
		var x = i - 1
		var y = j + dx
		if x >= 0 and y >= 0 and x < 12 and y < 12 and chessBoard[x][y] != "x":
			attack_piece_white_on_the_chessboard[x][y] += 1

func knightAttackWhite(i, j, chessBoard, attack_piece_white_on_the_chessboard):
	var knight_moves = [
		Vector2(-2, -1), Vector2(-2, 1),
		Vector2(-1, 2), Vector2(1, 2),
		Vector2(2, -1), Vector2(2, 1),
		Vector2(-1, -2), Vector2(1, -2)]
		
	for move in knight_moves:
		var x = i + move.x
		var y = j + move.y
		if x >= 0 and x < 12 and y >= 0 and y < 12 and chessBoard[x][y] != "x":
			attack_piece_white_on_the_chessboard[x][y] += 1

func bishopAttackWhite(i, j, dx, dy, attack_piece_white_on_the_chessboard):
	for f in range(1, 9):
		var x = i + dx * f
		var y = j + dy * f
		
		if x < 0 || x >= 12 || y < 0 || y >= 12 || chessBoard[x][y] == "x":
			break
		elif chessBoard[x][y] != "0":
			if chessBoard[x][y] == "KingBlack":
				if attack_piece_white_on_the_chessboard[x + dx][y + dy] <= -1:
					attack_piece_white_on_the_chessboard[x][y] += 1
					break
				else:
					attack_piece_white_on_the_chessboard[x][y] += 1
					attack_piece_white_on_the_chessboard[x + dx][y + dy] += 1
					break
			else:
				attack_piece_white_on_the_chessboard[x][y] += 1
				break
		else:
			attack_piece_white_on_the_chessboard[x][y] += 1

func rookAttackWhite(i, j, dx, dy, attack_piece_white_on_the_chessboard):
	for f in range(1, 9):
		var x = i + dx * f
		var y = j + dy * f
		
		if x < 0 || x >= 12 || y < 0 || y >= 12 || chessBoard[x][y] == "x":
			break
		elif chessBoard[x][y] != "0":
			if chessBoard[x][y] == "KingBlack":
				if attack_piece_white_on_the_chessboard[x + dx][y + dy] <= -1:
					attack_piece_white_on_the_chessboard[x][y] += 1
					break
				else:
					attack_piece_white_on_the_chessboard[x][y] += 1
					attack_piece_white_on_the_chessboard[x + dx][y + dy] += 1
					break
			else:
				attack_piece_white_on_the_chessboard[x][y] += 1
				break
		else:
			attack_piece_white_on_the_chessboard[x][y] += 1

func queenAttackWhite(i, j, attack_piece_white_on_the_chessboard):
	rookAttackWhite(i, j, -1, 0, attack_piece_white_on_the_chessboard)  # Vers le haut
	rookAttackWhite(i, j, 1, 0, attack_piece_white_on_the_chessboard)  # Vers le bas
	rookAttackWhite(i, j, 0, 1, attack_piece_white_on_the_chessboard)  # Vers la droite
	rookAttackWhite(i, j, 0, -1, attack_piece_white_on_the_chessboard)  # Vers la gauche
	bishopAttackWhite(i, j, -1, 1, attack_piece_white_on_the_chessboard)  # En haut à droite
	bishopAttackWhite(i, j, -1, -1, attack_piece_white_on_the_chessboard)  # En haut à gauche
	bishopAttackWhite(i, j, 1, 1, attack_piece_white_on_the_chessboard)  # En bas à droite
	bishopAttackWhite(i, j, 1, -1, attack_piece_white_on_the_chessboard)  # En bas à gauche

func kingAttackWhite(i, j, chessBoard, attack_piece_white_on_the_chessboard):
	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			if dx == 0 and dy == 0:
				continue  # Ignore la position actuelle du roi
			var x = i + dx
			var y = j + dy
				
			if x >= 0 and x < 12 and y >= 0 and y < 12 and chessBoard[x][y] != "x":
				attack_piece_white_on_the_chessboard[x][y] += 1

func pawnAttackBlack(i, j, chessBoard, attack_piece_black_on_the_chessboard):
	for dx in [-1, 1]:
		var x = i + 1
		var y = j + dx
		if x >= 0 and y >= 0 and x < 12 and y < 12 and chessBoard[x][y] != "x":
			attack_piece_black_on_the_chessboard[x][y] += 1

func knightAttackBlack(i, j, chessBoard, attack_piece_black_on_the_chessboard):
	var knight_moves = [
		Vector2(-2, -1), Vector2(-2, 1),
		Vector2(-1, 2), Vector2(1, 2),
		Vector2(2, -1), Vector2(2, 1),
		Vector2(-1, -2), Vector2(1, -2)]
		
	for move in knight_moves:
		var x = i + move.x
		var y = j + move.y
		if x >= 0 and x < 12 and y >= 0 and y < 12 and chessBoard[x][y] != "x":
			attack_piece_black_on_the_chessboard[x][y] += 1

func bishopAttackBlack(i, j, dx, dy, attack_piece_black_on_the_chessboard):
	for f in range(1, 9):
		var x = i + dx * f
		var y = j + dy * f
		
		if x < 0 || x >= 12 || y < 0 || y >= 12 || chessBoard[x][y] == "x":
			break
		elif chessBoard[x][y] != "0":
			if chessBoard[x][y] == "KingWhite":
				if attack_piece_black_on_the_chessboard[x + dx][y + dy] <= -1:
					attack_piece_black_on_the_chessboard[x][y] += 1
					break
				else:
					attack_piece_black_on_the_chessboard[x][y] += 1
					attack_piece_black_on_the_chessboard[x + dx][y + dy] += 1
					break
			else:
				attack_piece_black_on_the_chessboard[x][y] += 1
				break
		else:
			attack_piece_black_on_the_chessboard[x][y] += 1

func rookAttackBlack(i, j, dx, dy, attack_piece_black_on_the_chessboard):
	for f in range(1, 9):
		var x = i + dx * f
		var y = j + dy * f
		
		if x < 0 || x >= 12 || y < 0 || y >= 12 || chessBoard[x][y] == "x":
			break
		elif chessBoard[x][y] != "0":
			if chessBoard[x][y] == "KingWhite":
				if attack_piece_black_on_the_chessboard[x + dx][y + dy] <= -1:
					attack_piece_black_on_the_chessboard[x][y] += 1
					break
				else:
					attack_piece_black_on_the_chessboard[x][y] += 1
					attack_piece_black_on_the_chessboard[x + dx][y + dy] += 1
					break
			else:
				attack_piece_black_on_the_chessboard[x][y] += 1
				break
		else:
			attack_piece_black_on_the_chessboard[x][y] += 1

func queenAttackBlack(i, j, attack_piece_black_on_the_chessboard):
	rookAttackBlack(i, j, -1, 0, attack_piece_black_on_the_chessboard)  # Vers le haut
	rookAttackBlack(i, j, 1, 0, attack_piece_black_on_the_chessboard)  # Vers le bas
	rookAttackBlack(i, j, 0, 1, attack_piece_black_on_the_chessboard)  # Vers la droite
	rookAttackBlack(i, j, 0, -1, attack_piece_black_on_the_chessboard)  # Vers la gauche
	bishopAttackBlack(i, j, -1, 1, attack_piece_black_on_the_chessboard)  # En haut à droite
	bishopAttackBlack(i, j, -1, -1, attack_piece_black_on_the_chessboard)  # En haut à gauche
	bishopAttackBlack(i, j, 1, 1, attack_piece_black_on_the_chessboard)  # En bas à droite
	bishopAttackBlack(i, j, 1, -1, attack_piece_black_on_the_chessboard)  # En bas à gauche

func kingAttackBlack(i, j, chessBoard, attack_piece_black_on_the_chessboard):
	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			if dx == 0 and dy == 0:
				continue  # Ignore la position actuelle du roi
			var x = i + dx
			var y = j + dy
				
			if x >= 0 and x < 12 and y >= 0 and y < 12 and chessBoard[x][y] != "x":
				attack_piece_black_on_the_chessboard[x][y] += 1

func attackPiecesWhite():
	for i in range(12):
		for j in range(12):
			var piece = chessBoard[i][j]
			if piece.begins_with("PawnWhite"):
				pawnAttackWhite(i, j, chessBoard, attack_piece_white_on_the_chessboard)
						
			if piece.begins_with("KnightWhite"):
				knightAttackWhite(i, j, chessBoard, attack_piece_white_on_the_chessboard)
			
			if piece.begins_with("BishopWhite"):
				bishopAttackWhite(i, j, -1, 1, attack_piece_white_on_the_chessboard)  # En haut à droite
				bishopAttackWhite(i, j, -1, -1, attack_piece_white_on_the_chessboard)  # En haut à gauche
				bishopAttackWhite(i, j, 1, 1, attack_piece_white_on_the_chessboard)  # En bas à droite
				bishopAttackWhite(i, j, 1, -1, attack_piece_white_on_the_chessboard)  # En bas à gauche
				
			if piece.begins_with("RookWhite"):
				rookAttackWhite(i, j, -1, 0, attack_piece_white_on_the_chessboard)  # Vers le haut
				rookAttackWhite(i, j, 1, 0, attack_piece_white_on_the_chessboard)  # Vers le bas
				rookAttackWhite(i, j, 0, 1, attack_piece_white_on_the_chessboard)  # Vers la droite
				rookAttackWhite(i, j, 0, -1, attack_piece_white_on_the_chessboard)  # Vers la gauche
				
			if piece.begins_with("QueenWhite"):
				queenAttackWhite(i, j, attack_piece_white_on_the_chessboard)
			
			if piece == "KingWhite":
				kingAttackWhite(i, j, chessBoard, attack_piece_white_on_the_chessboard)
				
	printAttackWhite()

func attackPiecesBlack():
	for i in range(12):
		for j in range(12):
			var piece = chessBoard[i][j]
			if piece.begins_with("PawnBlack"):
				pawnAttackBlack(i, j, chessBoard, attack_piece_black_on_the_chessboard)
						
			if piece.begins_with("KnightBlack"):
				knightAttackBlack(i, j, chessBoard, attack_piece_black_on_the_chessboard)
			
			if piece.begins_with("BishopBlack"):
				bishopAttackBlack(i, j, -1, 1, attack_piece_black_on_the_chessboard)  # En haut à droite
				bishopAttackBlack(i, j, -1, -1, attack_piece_black_on_the_chessboard)  # En haut à gauche
				bishopAttackBlack(i, j, 1, 1, attack_piece_black_on_the_chessboard)  # En bas à droite
				bishopAttackBlack(i, j, 1, -1, attack_piece_black_on_the_chessboard)  # En bas à gauche
				
			if piece.begins_with("RookBlack"):
				rookAttackBlack(i, j, -1, 0, attack_piece_black_on_the_chessboard)  # Vers le haut
				rookAttackBlack(i, j, 1, 0, attack_piece_black_on_the_chessboard)  # Vers le bas
				rookAttackBlack(i, j, 0, 1, attack_piece_black_on_the_chessboard)  # Vers la droite
				rookAttackBlack(i, j, 0, -1, attack_piece_black_on_the_chessboard)  # Vers la gauche
				
			if piece.begins_with("QueenBlack"):
				queenAttackBlack(i, j, attack_piece_black_on_the_chessboard)
			
			if piece == "KingBlack":
				kingAttackBlack(i, j, chessBoard, attack_piece_black_on_the_chessboard)
					
	printAttackBlack()

func findAttackerDirectionRow(chessBoard,kingNode,piece1,piece2):
	var directions = ["Haut", "Bas", "Droite", "Gauche"]
	var i
	var j
	
	for direction in directions:
		for f in range(1, 9):
			if direction == "Haut":
				i = kingNode.i - f
				j = kingNode.j
			elif direction == "Bas":
				i = kingNode.i + f
				j = kingNode.j
			elif direction == "Droite":
				i = kingNode.i
				j = kingNode.j + f
			elif direction == "Gauche":
				i = kingNode.i
				j = kingNode.j - f
			
			if i < 0 or i >= 12 or j < 0 or j >= 12:
				break
			if chessBoard[i][j] == "x":
				break
			if chessBoard[i][j] != "0":
				var piece = chessBoard[i][j]
				if piece.begins_with(piece1) or piece.begins_with(piece2):
					attackerPositioni = i
					attackerPositionj = j
					directionOfAttack = direction
				else:
					break

func findAttackerDirectionDiagonal(chessBoard,kingNode,piece1,piece2):
	var directions = ["Haut/Droite", "Haut/Gauche", "Bas/Droite", "Bas/Gauche"]
	var i
	var j
	
	for direction in directions:
		for f in range(1, 9):
			if direction == "Haut/Droite":
				i = kingNode.i - f
				j = kingNode.j + f
			elif direction == "Haut/Gauche":
				i = kingNode.i - f
				j = kingNode.j - f
			elif direction == "Bas/Droite":
				i = kingNode.i + f
				j = kingNode.j + f
			elif direction == "Bas/Gauche":
				i = kingNode.i + f
				j = kingNode.j - f
			
			if i < 0 or i >= 12 or j < 0 or j >= 12:
				break
			if chessBoard[i][j] == "x":
				break
			if chessBoard[i][j] != "0":
				var piece = chessBoard[i][j]
				if piece.begins_with(piece1) or piece.begins_with(piece2):
					attackerPositioni = i
					attackerPositionj = j
					directionOfAttack = direction
				else:
					break

func findAttackerDirectionKnight(chessBoard,kingNode,piece):
	var knight_moves = [
		Vector2(-2, -1), Vector2(-2, 1),
		Vector2(-1, 2), Vector2(1, 2),
		Vector2(2, -1), Vector2(2, 1),
		Vector2(-1, -2), Vector2(1, -2)]

	for move in knight_moves:
		var dx = move[0]
		var dy = move[1]
		
		var target_i = kingNode.i + dx
		var target_j = kingNode.j + dy

		if target_i >= 0 and target_i < 12 and target_j >= 0 and target_j < 12:
			var target_piece = chessBoard[target_i][target_j]

			if target_piece != "x" and target_piece.begins_with(piece):
				attackerPositioni = target_i
				attackerPositionj = target_j
				directionOfAttack = "Cavalier"
				break

func findAttackerDirectionPawnWhite(chessBoard,kingNode):
	#Vers le bas à droite
		if chessBoard[kingNode.i+1][kingNode.j+1] == "x":
			pass
		elif chessBoard[kingNode.i+1][kingNode.j+1] != "0":
			
			if chessBoard[kingNode.i+1][kingNode.j+1].begins_with("PawnWhite"):
				attackerPositioni = kingNode.i+1
				attackerPositionj = kingNode.j+1
				directionOfAttack = "Bas/Droite"
				
		#Vers le bas à gauche
		if chessBoard[kingNode.i+1][kingNode.j-1] == "x":
			pass
		elif chessBoard[kingNode.i+1][kingNode.j-1] != "0":
			
			if chessBoard[kingNode.i+1][kingNode.j-1].begins_with("PawnWhite"):
				attackerPositioni = kingNode.i+1
				attackerPositionj = kingNode.j-1
				directionOfAttack = "Bas/Gauche"

func findAttackerDirectionPawnBlack(chessBoard,kingNode):
	#Vers le haut à droite
		if chessBoard[kingNode.i-1][kingNode.j+1] == "x":
			pass
		elif chessBoard[kingNode.i-1][kingNode.j+1] != "0":
			
			if chessBoard[kingNode.i-1][kingNode.j+1].begins_with("PawnBlack"):
				attackerPositioni = kingNode.i-1
				attackerPositionj = kingNode.j+1
				directionOfAttack = "Haut/Droite"
				
		#Vers le haut à gauche
		if chessBoard[kingNode.i-1][kingNode.j-1] == "x":
			pass
		elif chessBoard[kingNode.i-1][kingNode.j-1] != "0":
			
			if chessBoard[kingNode.i-1][kingNode.j-1].begins_with("PawnBlack"):
				attackerPositioni = kingNode.i-1
				attackerPositionj = kingNode.j-1
				directionOfAttack = "Haut/Gauche"

func checkingDirectionOfAttack(chessBoard,kingNode,knightColor,bishopColor,rookColor,queenColor,kingColor):
	#Vérifier dans quelle direction vient l'attaque (référenciel du Roi)
	if kingColor == "KingBlack":
		findAttackerDirectionPawnBlack(chessBoard,kingNode)
	elif kingColor == "KingWhite":
		findAttackerDirectionPawnWhite(chessBoard,kingNode)
	findAttackerDirectionRow(chessBoard,kingNode,rookColor,queenColor)
	findAttackerDirectionDiagonal(chessBoard,kingNode,bishopColor,queenColor)
	findAttackerDirectionKnight(chessBoard,kingNode,knightColor)

func searchDefenderRow(attackerPositionILoop,attackerPositionJLoop,piece1,piece2):
	print("Enter in searchDefenderRow")
	var directions = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]
	
	for direction in directions:
		var dx = direction[0]
		var dy = direction[1]
		
		for ff in range(1,9):
			var target_i = attackerPositionILoop + ff * dx
			var target_j = attackerPositionJLoop + ff * dy
			
			if target_i < 0 or target_i >= 12 or target_j < 0 or target_j >= 12:
				break
				
			var target_piece = chessBoard[target_i][target_j]
			
			if target_piece == "x":
				break
			elif target_piece != "0":
				print("target_piece: ", target_piece)
				if target_piece.begins_with(piece1) or target_piece.begins_with(piece2):
					var attackerPositionShiftI = attackerPositionILoop
					var attackerPositionShiftJ = attackerPositionJLoop
					var defenseurPositionI = target_i
					var defenseurPositionJ = target_j
					pieceProtectTheKing = true
					print("pieceProtectTheKing: ", pieceProtectTheKing)
#					emit_signal("check_to_the_king", attackerPositionShiftI, attackerPositionShiftJ, defenseurPositionI, defenseurPositionJ, directionOfAttack)
					break
				else:
					break

func searchDefenderDiagonal(attackerPositionILoop,attackerPositionJLoop,piece1,piece2):
	print("Enter in searchDefenderDiagonal")
	var directions = [Vector2(1, 1), Vector2(-1, -1), Vector2(1, -1), Vector2(-1, 1)]
	
	for direction in directions:
		var dx = direction[0]
		var dy = direction[1]
		
		for ff in range(1,9):
			var target_i = attackerPositionILoop + ff * dx
			var target_j = attackerPositionJLoop + ff * dy
			
			if target_i < 0 or target_i >= 12 or target_j < 0 or target_j >= 12:
				break
				
			var target_piece = chessBoard[target_i][target_j]
			
			if target_piece == "x":
				break
			elif target_piece != "0":
				print("target_piece: ", target_piece)
				if target_piece.begins_with(piece1) or target_piece.begins_with(piece2):
					var attackerPositionShiftI = attackerPositionILoop
					var attackerPositionShiftJ = attackerPositionJLoop
					var defenseurPositionI = target_i
					var defenseurPositionJ = target_j
					pieceProtectTheKing = true
					print("pieceProtectTheKing: ", pieceProtectTheKing)
#					emit_signal("check_to_the_king", attackerPositionShiftI, attackerPositionShiftJ, defenseurPositionI, defenseurPositionJ, directionOfAttack)
					break
				else:
					break

func searchDefenderKnight(attackerPositionILoop,attackerPositionJLoop,piece):
	print("Enter in searchDefenderKnight")
	var directions = [
		Vector2(-2, -1), Vector2(-2, 1),
		Vector2(-1, 2), Vector2(1, 2),
		Vector2(2, -1), Vector2(2, 1),
		Vector2(-1, -2), Vector2(1, -2)]
	
	for direction in directions:
		var dx = direction[0]
		var dy = direction[1]
		
		var target_i = attackerPositionILoop + dx
		var target_j = attackerPositionJLoop + dy
		
#		if target_i >= 0 and target_i < 12 and target_j >= 0 and target_j < 12:
#			break
			
		var target_piece = chessBoard[target_i][target_j]
		
		if target_piece == "x":
			continue
		elif target_piece != "0":
			print("target_piece: ", target_piece)
			if target_piece.begins_with(piece):
				var attackerPositionShiftI = attackerPositionILoop
				var attackerPositionShiftJ = attackerPositionJLoop
				
				var defenseurPositionI = target_i
				var defenseurPositionJ = target_j
				pieceProtectTheKing = true
				print("pieceProtectTheKing: ", pieceProtectTheKing)
				#emit_signal("check_to_the_king", attackerPositionShiftI, attackerPositionShiftJ, defenseurPositionI, defenseurPositionJ, directionOfAttack)

func searchDefenderPawnWhite(attack1, attack2):
	print("Enter in searchDefenderPawnWhite")
	if attack1 == true:
	#Vers le bas à droite
		print("ffpwd: ",chessBoard[attackerPositioni+1][attackerPositionj+1])
		if chessBoard[attackerPositioni+1][attackerPositionj+1] == "x":
			pass
		elif chessBoard[attackerPositioni+1][attackerPositionj+1] != "0":
			print("ffpwd: ",chessBoard[attackerPositioni+1][attackerPositionj+1])
			if chessBoard[attackerPositioni+1][attackerPositionj+1].begins_with("PawnWhite"):
				var attackerPositionShiftI = attackerPositioni
				var attackerPositionShiftJ = attackerPositionj
				
				var defenseurPositionI = attackerPositioni+1
				var defenseurPositionJ = attackerPositionj+1
				pieceProtectTheKing = true
				print("pieceProtectTheKing: ", pieceProtectTheKing)
#				emit_signal("check_to_the_king",attackerPositionShiftI,attackerPositionShiftJ\
#				,defenseurPositionI,defenseurPositionJ,directionOfAttack)
	if attack2 == true:
		#Vers le bas à gauche
		print("ffpwg: ",chessBoard[attackerPositioni+1][attackerPositionj-1])
		if chessBoard[attackerPositioni+1][attackerPositionj-1] == "x":
			pass
		elif chessBoard[attackerPositioni+1][attackerPositionj-1] != "0":
			print("ffpwg: ",chessBoard[attackerPositioni+1][attackerPositionj-1])
			if chessBoard[attackerPositioni+1][attackerPositionj-1].begins_with("PawnWhite"):
				var attackerPositionShiftI = attackerPositioni
				var attackerPositionShiftJ = attackerPositionj
				
				var defenseurPositionI = attackerPositioni+1
				var defenseurPositionJ = attackerPositionj-1
				pieceProtectTheKing = true
				print("pieceProtectTheKing: ", pieceProtectTheKing)
				#emit_signal("check_to_the_king",attackerPositionShiftI,attackerPositionShiftJ\
				#,defenseurPositionI,defenseurPositionJ,directionOfAttack)

func searchDefenderPawnBlack(attack1, attack2):
	print("Enter in searchDefenderPawnBlack")
	if attack1 == true:
	#Vers le haut à droite
		print("ffpbd: ",chessBoard[attackerPositioni-1][attackerPositionj+1])
		if chessBoard[attackerPositioni-1][attackerPositionj+1] == "x":
			pass
		elif chessBoard[attackerPositioni-1][attackerPositionj+1] != "0":
			print("ffpbd: ",chessBoard[attackerPositioni-1][attackerPositionj+1])
			if chessBoard[attackerPositioni-1][attackerPositionj+1].begins_with("PawnBlack"):
				var attackerPositionShiftI = attackerPositioni
				var attackerPositionShiftJ = attackerPositionj
				
				var defenseurPositionI = attackerPositioni-1
				var defenseurPositionJ = attackerPositionj+1
				pieceProtectTheKing = true
				print("pieceProtectTheKing: ", pieceProtectTheKing)
#				emit_signal("check_to_the_king",attackerPositionShiftI,attackerPositionShiftJ\
#				,defenseurPositionI,defenseurPositionJ,directionOfAttack)
	if attack2 == true:
		#Vers le haut à gauche
		print("ffpbg: ",chessBoard[attackerPositioni-1][attackerPositionj-1])
		if chessBoard[attackerPositioni-1][attackerPositionj-1] == "x":
			pass
		elif chessBoard[attackerPositioni-1][attackerPositionj-1] != "0":
			print("ffpbg: ",chessBoard[attackerPositioni-1][attackerPositionj-1])
			if chessBoard[attackerPositioni-1][attackerPositionj-1].begins_with("PawnBlack"):
				var attackerPositionShiftI = attackerPositioni
				var attackerPositionShiftJ = attackerPositionj
				
				var defenseurPositionI = attackerPositioni-1
				var defenseurPositionJ = attackerPositionj-1
				pieceProtectTheKing = true
				print("pieceProtectTheKing: ", pieceProtectTheKing)
				#emit_signal("check_to_the_king",attackerPositionShiftI,attackerPositionShiftJ\
				#,defenseurPositionI,defenseurPositionJ,directionOfAttack)

func attackComingUp(knightColor,bishopColor,rookColor,queenColor,kingColor):
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant du haut, on descend chaque case jusqu'au roi
	#Pawns
	if kingColor == "KingWhite":
		searchDefenderPawnWhite(true,true)
	elif kingColor == "KingBlack":
		searchDefenderPawnBlack(true,true)
	#Lignes et cavaliers
	for f in range(9):
		var attackerPositionILoop = attackerPositioni + f
		var attackerPositionJLoop = attackerPositionj
		print("attackerPositionILoop: ",attackerPositionILoop)
		print("attackerPositionJLoop: ",attackerPositionJLoop)
		print("piece name: ", chessBoard[attackerPositionILoop][attackerPositionJLoop])
		if chessBoard[attackerPositionILoop][attackerPositionJLoop] != kingColor:
			searchDefenderRow(attackerPositionILoop,attackerPositionJLoop,rookColor,queenColor)
			searchDefenderDiagonal(attackerPositionILoop,attackerPositionJLoop,bishopColor,queenColor)
			searchDefenderKnight(attackerPositionILoop,attackerPositionJLoop,knightColor)
		else:
			break

func attackComingDown(knightColor,bishopColor,rookColor,queenColor,kingColor):
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant du bas, on monte chaque case jusqu'au roi
	#Pawns
	if kingColor == "KingWhite":
		searchDefenderPawnWhite(true,true)
	elif kingColor == "KingBlack":
		searchDefenderPawnBlack(true,true)
	#Lignes et cavaliers
	for f in range(9):
		var attackerPositionILoop = attackerPositioni - f
		var attackerPositionJLoop = attackerPositionj
		print("attackerPositionILoop: ",attackerPositionILoop)
		print("attackerPositionJLoop: ",attackerPositionJLoop)
		print("piece name: ", chessBoard[attackerPositionILoop][attackerPositionJLoop])
		if chessBoard[attackerPositionILoop][attackerPositionJLoop] != kingColor:
			searchDefenderRow(attackerPositionILoop,attackerPositionJLoop,rookColor,queenColor)
			searchDefenderDiagonal(attackerPositionILoop,attackerPositionJLoop,bishopColor,queenColor)
			searchDefenderKnight(attackerPositionILoop,attackerPositionJLoop,knightColor)
		else:
			break

func attackComingRight(knightColor,bishopColor,rookColor,queenColor,kingColor):
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant de la droite, on va vers la gauche pour trouver le roi
	#Pawns
	if kingColor == "KingWhite":
		searchDefenderPawnWhite(true,true)
	elif kingColor == "KingBlack":
		searchDefenderPawnBlack(true,true)
	#Lignes et cavaliers
	for f in range(9):
		var attackerPositionILoop = attackerPositioni
		var attackerPositionJLoop = attackerPositionj - f
		print("attackerPositionILoop: ",attackerPositionILoop)
		print("attackerPositionJLoop: ",attackerPositionJLoop)
		print("piece name: ", chessBoard[attackerPositionILoop][attackerPositionJLoop])
		if chessBoard[attackerPositionILoop][attackerPositionJLoop] != kingColor:
			searchDefenderRow(attackerPositionILoop,attackerPositionJLoop,rookColor,queenColor)
			searchDefenderDiagonal(attackerPositionILoop,attackerPositionJLoop,bishopColor,queenColor)
			searchDefenderKnight(attackerPositionILoop,attackerPositionJLoop,knightColor)
		else:
			break

func attackComingLeft(knightColor,bishopColor,rookColor,queenColor,kingColor):
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant de la gauche, on va vers la droite pour trouver le roi
	#Pawns
	if kingColor == "KingWhite":
		searchDefenderPawnWhite(true,true)
	elif kingColor == "KingBlack":
		searchDefenderPawnBlack(true,true)
	#Lignes et cavaliers
	for f in range(9):
		var attackerPositionILoop = attackerPositioni
		var attackerPositionJLoop = attackerPositionj + f
		print("attackerPositionILoop: ",attackerPositionILoop)
		print("attackerPositionJLoop: ",attackerPositionJLoop)
		print("piece name: ", chessBoard[attackerPositionILoop][attackerPositionJLoop])
		if chessBoard[attackerPositionILoop][attackerPositionJLoop] != kingColor:
			searchDefenderRow(attackerPositionILoop,attackerPositionJLoop,rookColor,queenColor)
			searchDefenderDiagonal(attackerPositionILoop,attackerPositionJLoop,bishopColor,queenColor)
			searchDefenderKnight(attackerPositionILoop,attackerPositionJLoop,knightColor)
		else:
			break

func attackComingUpRight(knightColor,bishopColor,rookColor,queenColor,kingColor):
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant du haut à droite, on va vers bas à gauche pour trouver le roi
	#Pawns
	if kingColor == "KingWhite":
		searchDefenderPawnWhite(true,false)
	elif kingColor == "KingBlack":
		searchDefenderPawnBlack(false,true)
	#Lignes et cavaliers
	for f in range(9):
		var attackerPositionILoop = attackerPositioni + f
		var attackerPositionJLoop = attackerPositionj - f
		print("attackerPositionILoop: ",attackerPositionILoop)
		print("attackerPositionJLoop: ",attackerPositionJLoop)
		print("piece name: ", chessBoard[attackerPositionILoop][attackerPositionJLoop])
		if chessBoard[attackerPositionILoop][attackerPositionJLoop] != kingColor:
			searchDefenderRow(attackerPositionILoop,attackerPositionJLoop,rookColor,queenColor)
			searchDefenderDiagonal(attackerPositionILoop,attackerPositionJLoop,bishopColor,queenColor)
			searchDefenderKnight(attackerPositionILoop,attackerPositionJLoop,knightColor)
		else:
			break

func attackComingUpLeft(knightColor,bishopColor,rookColor,queenColor,kingColor):
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant du haut à gauche, on va vers bas à droite pour trouver le roi
	#Pawns
	if kingColor == "KingWhite":
		searchDefenderPawnWhite(false,true)
	elif kingColor == "KingBlack":
		searchDefenderPawnBlack(true,false)
	#Lignes et cavaliers
	for f in range(9):
		var attackerPositionILoop = attackerPositioni + f
		var attackerPositionJLoop = attackerPositionj + f
		print("attackerPositionILoop: ",attackerPositionILoop)
		print("attackerPositionJLoop: ",attackerPositionJLoop)
		print("piece name: ", chessBoard[attackerPositionILoop][attackerPositionJLoop])
		if chessBoard[attackerPositionILoop][attackerPositionJLoop] != kingColor:
			searchDefenderRow(attackerPositionILoop,attackerPositionJLoop,rookColor,queenColor)
			searchDefenderDiagonal(attackerPositionILoop,attackerPositionJLoop,bishopColor,queenColor)
			searchDefenderKnight(attackerPositionILoop,attackerPositionJLoop,knightColor)
		else:
			break

func attackComingDownRight(knightColor,bishopColor,rookColor,queenColor,kingColor):
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant du bas à droite, on va vers haut à gauche pour trouver le roi
	#Pawns
	if kingColor == "KingWhite":
		searchDefenderPawnWhite(true,true)
	elif kingColor == "KingBlack":
		searchDefenderPawnBlack(true,true)
	#Lignes et cavaliers
	for f in range(9):
		var attackerPositionILoop = attackerPositioni - f
		var attackerPositionJLoop = attackerPositionj - f
		print("attackerPositionILoop: ",attackerPositionILoop)
		print("attackerPositionJLoop: ",attackerPositionJLoop)
		print("piece name: ", chessBoard[attackerPositionILoop][attackerPositionJLoop])
		if chessBoard[attackerPositionILoop][attackerPositionJLoop] != kingColor:
			searchDefenderRow(attackerPositionILoop,attackerPositionJLoop,rookColor,queenColor)
			searchDefenderDiagonal(attackerPositionILoop,attackerPositionJLoop,bishopColor,queenColor)
			searchDefenderKnight(attackerPositionILoop,attackerPositionJLoop,knightColor)
		else:
			break

func attackComingDownLeft(knightColor,bishopColor,rookColor,queenColor,kingColor):
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant du bas à gauche, on va vers haut à droite pour trouver le roi
	#Pawns
	if kingColor == "KingWhite":
		searchDefenderPawnWhite(true,true)
	elif kingColor == "KingBlack":
		searchDefenderPawnBlack(true,true)
	#Lignes et cavaliers
	for f in range(9):
		var attackerPositionILoop = attackerPositioni - f
		var attackerPositionJLoop = attackerPositionj + f
		print("attackerPositionILoop: ",attackerPositionILoop)
		print("attackerPositionJLoop: ",attackerPositionJLoop)
		print("piece name: ", chessBoard[attackerPositionILoop][attackerPositionJLoop])
		if chessBoard[attackerPositionILoop][attackerPositionJLoop] != kingColor:
			searchDefenderRow(attackerPositionILoop,attackerPositionJLoop,rookColor,queenColor)
			searchDefenderDiagonal(attackerPositionILoop,attackerPositionJLoop,bishopColor,queenColor)
			searchDefenderKnight(attackerPositionILoop,attackerPositionJLoop,knightColor)
		else:
			break

func attackComingKnight(knightColor,bishopColor,rookColor,queenColor,kingColor):
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant du cavalier, on cherche qui peut le prendre
	#Pawns
	if kingColor == "KingWhite":
		searchDefenderPawnWhite(true,true)
	elif kingColor == "KingBlack":
		searchDefenderPawnBlack(true,true)
	#Lignes et cavaliers
	var attackerPositionILoop = attackerPositioni
	var attackerPositionJLoop = attackerPositionj
	print("attackerPositionILoop: ",attackerPositionILoop)
	print("attackerPositionJLoop: ",attackerPositionJLoop)
	print("piece name: ", chessBoard[attackerPositionILoop][attackerPositionJLoop])
	searchDefenderRow(attackerPositionILoop,attackerPositionJLoop,rookColor,queenColor)
	searchDefenderDiagonal(attackerPositionILoop,attackerPositionJLoop,bishopColor,queenColor)
	searchDefenderKnight(attackerPositionILoop,attackerPositionJLoop,knightColor)

func verificationDefenderAllAttack(knightColor,bishopColor,rookColor,queenColor,kingColor):
	if directionOfAttack == "Haut":
		print("Enter AttackCommingUp")
		attackComingUp(knightColor,bishopColor,rookColor,queenColor,kingColor)
	elif directionOfAttack == "Bas":
		print("Enter AttackCommingDown")
		attackComingDown(knightColor,bishopColor,rookColor,queenColor,kingColor)
	elif directionOfAttack == "Droite":
		print("Enter AttackCommingRight")
		attackComingRight(knightColor,bishopColor,rookColor,queenColor,kingColor)
	elif directionOfAttack == "Gauche":
		print("Enter AttackCommingLeft")
		attackComingLeft(knightColor,bishopColor,rookColor,queenColor,kingColor)
	elif directionOfAttack == "Haut/Droite":
		print("Enter AttackCommingUpRight")
		attackComingUpRight(knightColor,bishopColor,rookColor,queenColor,kingColor)
	elif directionOfAttack == "Haut/Gauche":
		print("Enter AttackCommingUpLeft")
		attackComingUpLeft(knightColor,bishopColor,rookColor,queenColor,kingColor)
	elif directionOfAttack == "Bas/Droite":
		print("Enter AttackCommingDownRight")
		attackComingDownRight(knightColor,bishopColor,rookColor,queenColor,kingColor)
	elif directionOfAttack == "Bas/Gauche":
		print("Enter AttackCommingDownLeft")
		attackComingDownLeft(knightColor,bishopColor,rookColor,queenColor,kingColor)
	elif directionOfAttack == "Cavalier":
		print("Enter AttackCommingKnight")
		attackComingKnight(knightColor,bishopColor,rookColor,queenColor,kingColor)

func verificationCheckAndCheckmate():
	var KingWhite = get_node("/root/ChessBoard/KingWhite")
	var KingBlack = get_node("/root/ChessBoard/KingBlack")
	
	if turnWhite == true:
		if attack_piece_white_on_the_chessboard[KingBlack.i][KingBlack.j] == 0:
			checkBlack = false
			pieceProtectTheKing = false
		if attack_piece_black_on_the_chessboard[KingWhite.i][KingWhite.j] >= 1:
			checkWhite = true
			
			checkingDirectionOfAttack(chessBoard,KingWhite,"KnightBlack","BishopBlack","RookBlack","QueenBlack","KingBlack")
			print("directionOfAttack: ",directionOfAttack)
			
			verificationDefenderAllAttack("KnightWhite","BishopWhite","RookWhite","QueenWhite","KingWhite")
			
		print("King White check: ", checkWhite)
		print("King Black check: ", checkBlack)
		
	else:
		if attack_piece_black_on_the_chessboard[KingWhite.i][KingWhite.j] == 0:
			checkWhite = false
			pieceProtectTheKing = false
		if attack_piece_white_on_the_chessboard[KingBlack.i][KingBlack.j] >= 1:
			checkBlack = true
			
			checkingDirectionOfAttack(chessBoard,KingBlack,"KnightWhite","BishopWhite","RookWhite","QueenWhite","KingWhite")
			print("directionOfAttack: ",directionOfAttack)
			
			verificationDefenderAllAttack("KnightBlack","BishopBlack","RookBlack","QueenBlack","KingBlack")
			
		print("King White check: ", checkWhite)
		print("King Black check: ", checkBlack)
