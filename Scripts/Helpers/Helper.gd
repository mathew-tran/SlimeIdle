extends Node

func AddMessage(text):
	return
	# Removed until needed.
	get_tree().get_nodes_in_group("LogBox")[0].AddText(text)

func GetInventory():
	return get_tree().get_nodes_in_group("Inventory")[0]
	
func GetInventoryPanel():
	return get_tree().get_nodes_in_group("InventoryPanel")[0]
	
func GetTechPanel():
	return get_tree().get_nodes_in_group("TechPanel")[0]
	
func GetSlimes():
	return get_tree().get_nodes_in_group("Slime")

func GetSlimeGroup():
	return get_tree().get_nodes_in_group("SlimeGroup")[0]

func GetSlimePanel():
	return get_tree().get_nodes_in_group("SlimePanel")[0]
	
func GetSlimeAssignPanel():
	return get_tree().get_nodes_in_group("SlimeAssignPanel")[0]

func GetSound():
	return get_tree().get_nodes_in_group("SoundManager")[0]
	
func GetFormattedAmount(amount):
	var score = str(amount)
	if amount <= 1:
		return score	
	var i : int = score.length() - 3
	while i > 0:
		score = score.insert(i, ",")
		i = i - 3
	return score
