extends Sprite2D

var promotionID

func _ready():
	pass

func _process(delta):
	pass

func blockMoveDuringPromotion(promoteInProgress):
	var numberOfChildren = get_child_count()
	
	for f in range(numberOfChildren):
		var pieceName = get_child(f)
		if pieceName.has_method("get_promoteInProgress"):
			# Le nœud a une méthode pour récupérer promoteInProgress
			var promoteInProgressValue = pieceName.get_promoteInProgress()
			if promoteInProgressValue != null:
				#print("Variable existe dans: ", pieceName.get_name())
				pieceName.promoteInProgress = promoteInProgress
				#print("pieceName.promoteInProgress: ", pieceName.promoteInProgress)
			else:
				pass
				#print("Variable est nulle dans: ", pieceName.get_name())
		else:
			pass
			#print("La méthode get_promoteInProgress n'existe pas dans: ", pieceName.get_name())

func updateVariablePiecePromoted():
	var numberOfChildren = get_child_count()
	
	for f in range(numberOfChildren):
		var pieceName = get_child(f)
		if pieceName.get_instance_id() == promotionID:
			pieceName.i = 2
			pieceName.j = 3
			pieceName.Position = Vector2(150, 50)
			pieceName.nameOfPiece = VariableGlobal.chessBoard[pieceName.i][pieceName.j]
			pieceName.initialPosition = false

func _on_pawn_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_2_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_2_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_3_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_3_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_4_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_4_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_5_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_5_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_6_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_6_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_7_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_7_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_8_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_8_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_9_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_9_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_10_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_10_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_11_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_11_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_12_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_12_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_13_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_13_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_14_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_14_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_15_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_15_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_16_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_16_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_script_changed():
	updateVariablePiecePromoted()

func _on_pawn_2_script_changed():
	updateVariablePiecePromoted()

func _on_pawn_3_script_changed():
	updateVariablePiecePromoted()

func _on_pawn_4_script_changed():
	updateVariablePiecePromoted()

func _on_pawn_5_script_changed():
	updateVariablePiecePromoted()

func _on_pawn_6_script_changed():
	updateVariablePiecePromoted()

func _on_pawn_7_script_changed():
	updateVariablePiecePromoted()

func _on_pawn_8_script_changed():
	updateVariablePiecePromoted()

func _on_pawn_9_script_changed():
	updateVariablePiecePromoted()

func _on_pawn_10_script_changed():
	updateVariablePiecePromoted()

func _on_pawn_11_script_changed():
	updateVariablePiecePromoted()

func _on_pawn_12_script_changed():
	updateVariablePiecePromoted()

func _on_pawn_13_script_changed():
	updateVariablePiecePromoted()

func _on_pawn_14_script_changed():
	updateVariablePiecePromoted()

func _on_pawn_15_script_changed():
	updateVariablePiecePromoted()

func _on_pawn_16_script_changed():
	updateVariablePiecePromoted()
