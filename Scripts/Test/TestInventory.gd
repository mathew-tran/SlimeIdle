extends "res://Scripts/Test/Test.gd"

export var bCheatResources = false
export var CheatedResourceAmount = 4000

func _ready():
	if bCheatResources:
		CheatResources()
		
func RunTest():	
	var reward = GameResources.Reward.new()
	reward.ResourceType = 0
	reward.Amount = 1
	Helper.GetInventory().AddItem(reward)
	
	# Check if it got added
	if Helper.GetInventory().CheckIfItemExists(GameResources.GetResName(0), reward.Amount) == false:
		failureReason.append("Expected to see item added to inventory, but did not find anything")
	if Helper.GetInventory().CheckIfItemExists(GameResources.GetResName(1), reward.Amount) == true:
		failureReason.append("Expected to see this item not added, but it was")
	
	# Check if removal works
	Helper.GetInventory().RemoveItem(GameResources.GetResName(0), reward.Amount)
	if Helper.GetInventory().CheckIfItemExists(GameResources.GetResName(0), reward.Amount) == true:
		failureReason.append("Expected to see item to be removed from, but it still existed")
	return len(failureReason) == 0
func CheatResources():
	for type in range(0, len(GameResources.RESOURCE_TYPE)):
		var reward = GameResources.Reward.new()
		reward.ResourceType = type
		reward.Amount = CheatedResourceAmount
		Helper.GetInventory().AddItem(reward)
